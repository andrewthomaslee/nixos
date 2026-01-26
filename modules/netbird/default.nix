{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.networking.netbird;
in {
  options.clan-net.networking.netbird = {
    enable = lib.mkEnableOption "netbird";
    ui.enable = lib.mkEnableOption "netbird ui";
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.netbird = {
      share = true;
      prompts.clan-net-setup_key.persist = true;
      files.clan-net-setup_key = {};
    };

    services.netbird = {
      enable = true;
      clients.clan-net = {
        ui.enable = cfg.ui.enable;
        port = 51820;
        login = {
          enable = true;
          setupKeyFile = config.clan.core.vars.generators.netbird.files.clan-net-setup_key.path;
        };
      };
    };

    systemd.services.netbird-clan-net-login = {
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
        StartLimitIntervalSec = 0;
      };
      unitConfig = {
        StartLimitIntervalSec = 0; # Unlimited retries
      };
    };

    networking = {
      networkmanager.unmanaged = ["nb-clan-net"];
      firewall = {
        trustedInterfaces = ["nb-clan-net"];
        checkReversePath = "loose";
      };
    };
  };
}
