{
  self,
  clan-facts,
}: let
  domain = clan-facts.meta.domain;
in {
  inherit (clan-facts) meta;

  machines = {
    hp-notebook.tags = ["kde" "desktop" "madi"];

    nixos.tags = ["kde" "devMachine" "netsa"];
    ghost.tags = ["kde" "devMachine" "netsa"];

    kamrui-p1.tags = ["server" "netsa"];
  };

  instances = {
    kde = {
      module.input = "self";
      module.name = "@andrewthomaslee/kde";
      roles.kde.tags.kde = {};
      roles.kde.extraModules = [self.inputs.jovian.nixosModules.default];
    };

    user-root = {
      module.name = "users";
      roles.default.tags.all = {};
      roles.default.settings = {
        user = "root";
        share = true;
      };
      roles.default.extraModules = [./users/root.nix];
    };

    user-netsa = {
      module.name = "users";
      roles.default.tags.netsa = {};
      roles.default.settings = {
        user = "netsa";
        share = true;
      };
      roles.default.extraModules = [./users/netsa.nix];
    };

    user-madi = {
      module.name = "users";
      roles.default.tags.madi = {};
      roles.default.settings = {
        user = "madi";
        share = true;
      };
      roles.default.extraModules = [./users/madi.nix];
    };

    user-robot = {
      module.name = "users";
      roles.default.tags.server = {};
      roles.default.settings = {
        user = "robot";
        share = true;
      };
      roles.default.extraModules = [./users/robot.nix];
    };

    machine-type = {
      module.input = "self";
      module.name = "@andrewthomaslee/machine-type";
      roles.desktop.tags.desktop = {};
      roles.server.tags.server = {};
      roles.devMachine.tags.devMachine = {};
    };

    wireguard = {
      module.name = "wireguard";
      module.input = "clan-core";
      roles.controller.machines = {
        nixos.settings = {
          endpoint = "wireguard.${domain}";
          port = 51824;
        };
        kamrui-p1.settings = {
          endpoint = "wireguard.${domain}";
          port = 51823;
        };
      };
      roles.peer.machines = {
        ghost.settings = {
          controller = "kamrui-p1";
        };
        hp-notebook.settings = {
          controller = "kamrui-p1";
        };
      };
    };

    k3s = {
      module.name = "k3s";
      module.input = "k3s";
      roles.init.machines.kamrui-p1.settings = {
        serverAddr = "https://kamrui-p1.wireguard:6443";
        clusterCidr = {
          ipv4 = "10.42.0.0/16";
          ipv6 = "fd42::/56";
        };
        serviceCidr = {
          ipv4 = "10.43.0.0/16";
          ipv6 = "fd43::/112";
        };
      };
      roles.server.machines.kamrui-p1 = {};
      roles.default.machines.kamrui-p1.settings.nodeIP = "127.0.0.1,::1";
      roles.default.extraModules = [
        {
          networking = let
            interfaces = ["wireguard " "cilium+"];
          in {
            networkmanager.unmanaged = interfaces;
            firewall = {
              checkReversePath = "loose";
              trustedInterfaces = interfaces;
            };
          };
        }
      ];
      roles.server.extraModules = [
        {
          # k3s
          services.k3s = {
            extraFlags = [
              "--tls-san=kamrui-p1.wireguard"
              "--flannel-backend=none"
              "--disable-network-policy"
              "--disable-kube-proxy"
              "--disable=traefik"
              "--disable=servicelb"
            ];
          };
        }
        {
          services.k3s.autoDeployCharts = {
            cilium = {
              name = "cilium";
              version = "1.19.1";
              repo = "https://helm.cilium.io/";
              hash = "sha256-Uw7b6RnncNLlYcDZQ7An9wjdbH4EGsskGpIJ5G4HMVs=";
              targetNamespace = "kube-system";
              extraFieldDefinitions.spec.bootstrap = true;
              values = {
                devices = "lo";
                operator.replicas = 1;
                kubeProxyReplacement = true;
                k8sServiceHost = "127.0.0.1";
                k8sServicePort = "6443";

                ipv4.enabled = true;
                ipv6.enabled = true;

                ipam = {
                  mode = "kubernetes";
                  operator = {
                    clusterPoolIPv4PodCIDRList = ["10.43.0.0/16"];
                    clusterPoolIPv6PodCIDRList = ["fd43::/112"];
                  };
                };
              };
            };
          };
        }
      ];
    };

    importer = {
      module.name = "importer";
      roles.default.tags.all = {};
      # Import all modules from ./modules/<module-name> on all machines
      roles.default.extraModules = map (m: ./modules + "/${m}") (builtins.attrNames self.nixosModules);
    };
  };
}
