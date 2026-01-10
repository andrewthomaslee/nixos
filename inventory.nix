{
  self,
  clan-facts,
}:
{
  inherit (clan-facts) meta;

  machines = {
    nixos.tags = [ "desktop" ];
    ghost.tags = [ "desktop" ];

    kamrui-P1-0.tags = [ "server" ];
    helsinki-vps.tags = [ "server" ];
  };

  instances = {
    internet = {
      module.name = "internet";
      roles.default.machines = {
        helsinki-vps.settings.host = clan-facts.machines.helsinki-vps.networking.IPv4.address;
      };
    };

    desktop = {
      module.input = "self";
      module.name = "@andrewthomaslee/desktop";
      roles.kde.tags.desktop = { };
    };

    user-root = {
      module.name = "users";
      roles.default.tags.all = { };
      roles.default.settings = {
        user = "root";
        share = true;
      };
      roles.default.extraModules = [ ./users/root.nix ];
    };

    user-netsa = {
      module.name = "users";
      roles.default.tags.all = { };
      roles.default.settings = {
        user = "netsa";
        share = true;
      };
      roles.default.extraModules = [ ./users/netsa.nix ];
    };

    user-madi = {
      module.name = "users";
      roles.default.machines.nixos = { };
      roles.default.settings = {
        user = "madi";
        share = true;
      };
      roles.default.extraModules = [ ./users/madi.nix ];
    };

    user-robot = {
      module.name = "users";
      roles.default.tags = [ "server" ];
      roles.default.settings = {
        user = "robot";
        share = true;
      };
      roles.default.extraModules = [ ./users/robot.nix ];
    };

    machine-type = {
      module.input = "self";
      module.name = "@andrewthomaslee/machine-type";
      roles.desktop.tags.desktop = { };
      roles.server.tags.server = { };
    };

    importer = {
      module.name = "importer";
      roles.default.tags.all = { };
      # Import all modules from ./modules/<module-name> on all machines
      roles.default.extraModules = map (m: ./modules + "/${m}") (builtins.attrNames self.nixosModules);
    };
  };
}
