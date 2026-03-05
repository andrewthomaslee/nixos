{
  config,
  lib,
  clan-facts,
  ...
}: let
  cfg = config.clan-net.kubernetes.k3s.config.cilium;
  cidr = clan-facts.k3s.cluster-cidr;
  domain = builtins.head clan-facts.k3s.domains;
in {
  options.clan-net.kubernetes.k3s.config.cilium.enable = lib.mkEnableOption "cilium";

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      checkReversePath = "loose";
      allowedTCPPorts = [
        4240 # Cilium CNI health checks
      ];
      allowedUDPPorts = [
        8472 # Cilium CNI with VXLAN
        51871 # Cilium CNI with WireGuard
      ];
    };
    # k3s
    services.k3s = lib.optionalAttrs config.clan-net.kubernetes.k3s.manager.enable {
      extraFlags = [
        "--flannel-backend=none"
        "--disable-network-policy"
        "--disable-kube-proxy"
      ];
      autoDeployCharts = {
        cilium = {
          name = "cilium";
          version = "1.19.1";
          repo = "https://helm.cilium.io/";
          hash = "sha256-Uw7b6RnncNLlYcDZQ7An9wjdbH4EGsskGpIJ5G4HMVs=";
          targetNamespace = "kube-system";
          extraFieldDefinitions.spec.bootstrap = true;
          values = {
            operator.replicas = 1;
            kubeProxyReplacement = true;
            k8sServiceHost = "127.0.0.1";
            k8sServicePort = "6443";

            hubble = {
              enabled = true;
              relay.enabled = true;
              ui.enabled = true;
            };

            ipv4.enabled = true;
            ipv6.enabled = true;

            ipam = {
              mode = "kubernetes";
              operator = {
                clusterPoolIPv4PodCIDRList = [cidr.IPv4];
                clusterPoolIPv6PodCIDRList = [cidr.IPv6];
              };
            };
          };
          extraObjects = [
            {
              apiVersion = "networking.k8s.io/v1";
              kind = "Ingress";
              metadata = {
                name = "hubble-ui";
                namespace = "kube-system";
                annotations."traefik.ingress.kubernetes.io/router.entrypoints" = "web";
              };
              spec = {
                ingressClassName = "traefik";
                rules = [
                  {
                    host = "hubble.${domain}";
                    http = {
                      paths = [
                        {
                          path = "/";
                          pathType = "Prefix";
                          backend = {
                            service = {
                              name = "hubble-ui";
                              port.number = 80;
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
}
