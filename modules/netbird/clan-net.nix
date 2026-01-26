{
  config,
  lib,
  ...
}: let
  name = "clan-net";
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
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.netbird = {
      share = true;
      prompts."${name}-setup_key".persist = true;
      files."${name}-setup_key" = {};
    };

    services.netbird = {
      clients.${name} = {
        inherit (cfg) port;
        ui.enable = cfg.ui.enable;
        interface = name;
        login = {
          enable = true;
          setupKeyFile = config.clan.core.vars.generators.netbird.files."${name}-setup_key".path;
        };
      };
    };

    networking.firewall.trustedInterfaces = [name];

    systemd.services."netbird-${name}" = {
      after = ["network-online.target"];
      wants = ["network-online.target"];
    };
  };
}
