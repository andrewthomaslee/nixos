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

    importer = {
      module.name = "importer";
      roles.default.tags.all = {};
      # Import all modules from ./modules/<module-name> on all machines
      roles.default.extraModules = map (m: ./modules + "/${m}") (builtins.attrNames self.nixosModules);
    };
  };
}
