{
  config,
  lib,
  ...
}: let
  name = "clan-net";
  cfg = config.clan-net.networking.netbird;
in {
  options.clan-net.networking.netbird = {
    enable = lib.mkEnableOption "netbird";
    name = lib.mkOption {
      type = lib.types.str;
      description = "netbird interface name";
      example = "clan-net";
      default = name;
    };
    port = lib.mkOption {
      type = lib.types.int;
      description = "netbird port";
      example = 51821;
      default = 51820;
    };
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.netbird = {
      share = true;
      prompts."${cfg.name}-setup_key".persist = true;
      files."${cfg.name}-setup_key" = {};
    };

    services.netbird = {
      enable = true;
      useRoutingFeatures = "server";
      clients.${cfg.name} = {
        inherit (cfg) port;
        interface = cfg.name;
        login = {
          enable = true;
          setupKeyFile = config.clan.core.vars.generators.netbird.files."${cfg.name}-setup_key".path;
        };
      };
    };

    networking.firewall.trustedInterfaces = [cfg.name];
    users.extraGroups."netbird-${cfg.name}".members = ["netsa"];
  };
}
