{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.services.netbird;
in {
  options.clan-net.services.netbird = {
    enable = lib.mkEnableOption "netbird";
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.netbird = {
      share = true;
      prompts.setup_key.persist = true;
      files.setup_key = {};
    };

    services.netbird.clients.clan-net = {
      port = 51820;
      name = "netbird";
      interface = "clan-net";
      login = {
        enable = true;
        setupKeyFile = config.clan.core.vars.generators.netbird.files.setup_key.path;
      };
    };

    networking = {
      networkmanager.unmanaged = ["clan-net"];
      firewall = {
        trustedInterfaces = ["clan-net"];
        checkReversePath = "loose";
      };
    };
  };
}
