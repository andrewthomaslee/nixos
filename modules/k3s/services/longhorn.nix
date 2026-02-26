{
  config,
  lib,
  clan-facts,
  pkgs,
  ...
}: let
  cfg = config.clan-net.kubernetes.k3s.services.longhorn;
  hostName = config.networking.hostName;
  domain = builtins.head clan-facts.k3s.domains;
in {
  options.clan-net.kubernetes.k3s.services.longhorn.enable = lib.mkEnableOption "longhorn";

  config = lib.mkIf cfg.enable {
    # nixos config for longhorn
    services.openiscsi = {
      enable = true;
      name = "iqn.2016-04.com.open-iscsi:${hostName}";
    };
    environment.systemPackages = with pkgs; [
      cifs-utils
      nfs-utils
    ];
    systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];
    boot.initrd.kernelModules = ["dm_crypt"];

    # k3s
    services.k3s = {
      nodeLabel = ["storage=longhorn"];
      autoDeployCharts = lib.optionalAttrs config.clan-net.kubernetes.k3s.manager.enable {
        longhorn = {
          name = "longhorn";
          version = "v1.11.0";
          repo = "https://charts.longhorn.io";
          hash = "sha256-fpBaiw3DJ0KRQ1Co5AYjT/WuZR1LjD+Zq6hKg2CKG/Y=";
          createNamespace = true;
          targetNamespace = "longhorn-system";
          values = {
            longhornManager.nodeSelector.storage = "longhorn";
            longhornDriver.nodeSelector.storage = "longhorn";
            longhornUI.nodeSelector.storage = "longhorn";
            persistence.defaultNodeSelector.storage = "longhorn";
            defaultSettings = {
              backupCompressionMethod = "gzip";
              systemManagedComponentsNodeSelector = "storage:longhorn";
            };
            extraObjects = [
              {
                apiVersion = "networking.k8s.io/v1";
                kind = "Ingress";
                metadata = {
                  name = "longhorn";
                  namespace = "longhorn-system";
                  annotations."traefik.ingress.kubernetes.io/router.entrypoints" = "web";
                };
                spec = {
                  ingressClassName = "traefik";
                  rules = [
                    {
                      host = "longhorn.${domain}";
                      http = {
                        paths = [
                          {
                            path = "/";
                            pathType = "Prefix";
                            backend = {
                              service = {
                                name = "longhorn-frontend";
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
}
