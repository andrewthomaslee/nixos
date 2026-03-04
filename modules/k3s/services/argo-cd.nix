{
  config,
  lib,
  clan-facts,
  ...
}: let
  cfg = config.clan-net.kubernetes.k3s.services.argo-cd;
  domain = builtins.head clan-facts.k3s.domains;
in {
  options.clan-net.kubernetes.k3s.services.argo-cd.enable = lib.mkEnableOption "argo-cd";

  config = lib.mkIf cfg.enable {
    # k3s
    services.k3s.autoDeployCharts = lib.optionalAttrs config.clan-net.kubernetes.k3s.manager.enable {
      argo-cd = {
        name = "argo-cd";
        repo = "https://argoproj.github.io/argo-helm";
        version = "9.4.2";
        hash = "sha256-B4/iQMgfnhj57s0XN6AaDgcPmdYP7fL/Wj0MrdihuiM=";
        createNamespace = true;
        targetNamespace = "argocd";
        values = {
          namespaceOverride = "argocd";
          global.domain = "argocd.${domain}";
          configs = {
            secret.argocdServerAdminPassword = "${lib.trim (lib.removePrefix "admin:" config.clan.core.vars.generators.middleware-admin.files.hash.value)}";
            params."server.insecure" = "true";
          };
          extraObjects = [
            {
              apiVersion = "networking.k8s.io/v1";
              kind = "Ingress";
              metadata = {
                name = "argocd";
                namespace = "argocd";
                annotations."traefik.ingress.kubernetes.io/router.entrypoints" = "web";
              };
              spec = {
                ingressClassName = "traefik";
                tls = [
                  {
                    hosts = ["argocd.${domain}"];
                  }
                ];
                rules = [
                  {
                    host = "argocd.${domain}";
                    http = {
                      paths = [
                        {
                          path = "/";
                          pathType = "Prefix";
                          backend = {
                            service = {
                              name = "argo-cd-argocd-server";
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
}
