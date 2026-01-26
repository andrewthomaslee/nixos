{
  config,
  lib,
  ...
}: let
  name = "industrial-host";
  cfg = config.clan-net.networking.netbird.${name};
in {
  options.clan-net.networking.netbird.${name} = {
    enable = lib.mkEnableOption "netbird";
    ui.enable = lib.mkEnableOption "netbird ui";
    port = lib.mkOption {
      type = lib.types.int;
      description = "netbird port";
      example = 51820;
    };
    interface = lib.mkOption {
      type = lib.types.str;
      default = name;
      description = "interface name";
      example = "nb-interface";
    };
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.netbird = {
      share = true;
      prompts."${name}-setup_key".persist = true;
      files."${name}-setup_key" = {};
    };

    services.netbird = {
      clients.${name} = {
        inherit (cfg) port interface;
        ui.enable = cfg.ui.enable;
        login = {
          enable = true;
          setupKeyFile = config.clan.core.vars.generators.netbird.files."${name}-setup_key".path;
        };
      };
    };

    networking.firewall.trustedInterfaces = [name];
  };
}
