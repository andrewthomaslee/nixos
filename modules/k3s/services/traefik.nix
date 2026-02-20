{
  config,
  lib,
  clan-net-utils,
  clan-facts,
  ...
}: let
  inherit (clan-net-utils) writeYamlFile;
  cfg = config.clan-net.kubernetes.k3s.services.traefik;
  hostName = config.networking.hostName;
  net = clan-facts.networking.tailscale;
  managerIPv4 = net.IPv4.kamrui-p1;
  domain = clan-facts.k3s.domain;
  cidr = clan-facts.k3s.cluster-cidr;
  trustedIPs = [managerIPv4 cidr.IPv4 cidr.IPv6];
  extraConfig = ''
    import cloudflare_mtls
    reverse_proxy ${managerIPv4}:30080
  '';
in {
  options.clan-net.kubernetes.k3s.services.traefik.enable = lib.mkEnableOption "traefik";

  config = lib.mkIf cfg.enable {
    # caddy reverse proxy for traefik
    clan-net.services.caddy.enable = lib.mkDefault true;
    services.caddy.virtualHosts = lib.optionalAttrs (hostName == "kamrui-p1") {
      "${domain}, *.${domain}" = {
        inherit extraConfig;
      };
    };

    # k3s auto deploy config map for rancher traefik ingress
    services.k3s = {
      manifests = lib.optionalAttrs (hostName == "kamrui-p1") {
        traefik-config.source = writeYamlFile "traefik-config.yaml" {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChartConfig";
          metadata = {
            name = "traefik";
            namespace = "kube-system";
          };
          spec = {
            valuesContent = lib.generators.toYAML {} {
              service.type = "NodePort";
              deployment.kind = "Deployment";
              nodeSelector.role = "manager";

              ports = {
                web = {
                  port = 8000;
                  containerPort = 8000;
                  nodePort = 30080;
                  hostPort = null;
                  proxyProtocol = {inherit trustedIPs;};
                  forwardedHeaders = {inherit trustedIPs;};
                };
              };
              api = {
                dashboard = true;
                insecure = false;
              };
              ingressRoute = {
                dashboard = {
                  enabled = true;
                  entryPoints = ["web"];
                  matchRule = "Host(`kube.${domain}`)";
                };
              };
              ingressClass.enabled = true;
              providers = {
                kubernetesIngress.enabled = true;
                kubernetesGateway.enabled = true;
              };

              gateway.listeners.web = {
                port = 8000;
                protocol = "HTTP";
                namespacePolicy.from = "All";
              };

              logs = {
                general.level = "DEBUG";
                access.enabled = true;
              };
              metrics.prometheus.enabled = true;

              extraObjects = [
                # --- admin middleware --- #
                {
                  apiVersion = "v1";
                  kind = "Secret";
                  metadata = {
                    name = "middleware-admin-secret";
                    namespace = "kube-system";
                  };
                  type = "Opaque";
                  stringData.users = ''
                    ${lib.trim config.clan.core.vars.generators.middleware-admin.files.hash.value}
                  '';
                }
                {
                  apiVersion = "traefik.io/v1alpha1";
                  kind = "Middleware";
                  metadata = {
                    name = "middleware-admin";
                    namespace = "kube-system";
                  };
                  spec.basicAuth.secret = "middleware-admin-secret";
                }
                # --- user middleware --- #
                {
                  apiVersion = "v1";
                  kind = "Secret";
                  metadata = {
                    name = "middleware-user-secret";
                    namespace = "kube-system";
                  };
                  type = "Opaque";
                  stringData.users = ''
                    ${lib.trim config.clan.core.vars.generators.middleware-user.files.hash.value}
                  '';
                }
                {
                  apiVersion = "traefik.io/v1alpha1";
                  kind = "Middleware";
                  metadata = {
                    name = "middleware-user";
                    namespace = "kube-system";
                  };
                  spec.basicAuth.secret = "middleware-user-secret";
                }
                # --- whoami example deployment for testing --- #
                {
                  apiVersion = "v1";
                  kind = "Namespace";
                  metadata.name = "whoami";
                }
                {
                  apiVersion = "apps/v1";
                  kind = "DaemonSet";
                  metadata = {
                    name = "whoami";
                    namespace = "whoami";
                  };
                  spec = {
                    selector.matchLabels.app = "whoami";
                    template = {
                      metadata.labels.app = "whoami";
                      spec = {
                        securityContext = {
                          runAsNonRoot = true;
                          runAsUser = 1000;
                          runAsGroup = 1000;
                          fsGroup = 1000;
                          seccompProfile.type = "RuntimeDefault";
                        };
                        containers = [
                          {
                            name = "whoami";
                            image = "traefik/whoami";
                            args = [
                              "--port"
                              "8080"
                            ];
                            ports = [
                              {containerPort = 8080;}
                            ];
                            securityContext = {
                              allowPrivilegeEscalation = false;
                              capabilities = {
                                drop = ["ALL"];
                              };
                            };
                          }
                        ];
                      };
                    };
                  };
                }
                {
                  apiVersion = "v1";
                  kind = "Service";
                  metadata = {
                    name = "whoami";
                    namespace = "whoami";
                  };
                  spec = {
                    ipFamilyPolicy = "PreferDualStack";
                    ipFamilies = [
                      "IPv4"
                      "IPv6"
                    ];
                    selector.app = "whoami";
                    ports = [
                      {
                        port = 80;
                        targetPort = 8080;
                      }
                    ];
                  };
                }
                {
                  apiVersion = "networking.k8s.io/v1";
                  kind = "Ingress";
                  metadata = {
                    name = "whoami";
                    namespace = "whoami";
                    annotations."traefik.ingress.kubernetes.io/router.entrypoints" = "web";
                  };
                  spec = {
                    ingressClassName = "traefik";
                    rules = [
                      {
                        host = "whoami-kube.${domain}";
                        http = {
                          paths = [
                            {
                              path = "/whoami";
                              pathType = "Prefix";
                              backend = {
                                service = {
                                  name = "whoami";
                                  port = {
                                    number = 80;
                                  };
                                };
                              };
                            }
                          ];
                        };
                      }
                    ];
                  };
                }
              ];
            };
          };
        };
      };
    };
  };
}
