{
  self,
  clan-facts,
}: {
  inherit (clan-facts) meta;

  machines = {
    hp-notebook.tags = ["kde" "desktop" "madi"];

    nixos.tags = ["kde" "devMachine" "netsa"];
    ghost.tags = ["kde" "devMachine" "netsa"];

    kamrui-p1.tags = ["server" "netsa"];
    hel-1.tags = ["server" "netsa"];
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
      module.name = "wireguard-fullmesh";
      module.input = "wireguard-fullmesh";
      roles.peer.machines = {
        kamrui-p1.settings = {
          endpoint = "wireguard.andrewlee.fun";
          port = 51823;
          ipv4 = "10.100.0.1";
          ipv6 = "fd10::1";
        };
        hel-1.settings = {
          endpoint = "wireguard.andrewlee.cloud";
          port = 51820;
          ipv4 = "10.100.0.2";
          ipv6 = "fd10::2";
        };
      };
    };

    homelab = let
      clusterSettings = clan-facts.kubernetes.homelab;
    in {
      module.name = "k3s";
      module.input = "k3s";
      roles.init.machines.kamrui-p1.settings = {
        serverAddr = "https://${clusterSettings.serverAddr}:6443";
        inherit (clusterSettings) clusterCidr serviceCidr;
      };
      roles.server.machines.kamrui-p1 = {};
      roles.default.machines.kamrui-p1.settings.nodeIP = "10.100.0.1,fd10::1";
      roles.default.extraModules = [
        modules/k3s/manifests/cilium
        {
          clan-net.kubernetes.cilium = {
            inherit (clusterSettings) id name;
          };

          networking.firewall = {
            # web traffic
            allowedTCPPorts = [
              80
              443
            ];
            # node port range
            allowedTCPPortRanges = [
              {
                from = 30000;
                to = 32767;
              }
            ];
          };
        }
      ];
      roles.server.extraModules = [
        {
          services.k3s.extraFlags = [
            "--disable=traefik"
          ];
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
