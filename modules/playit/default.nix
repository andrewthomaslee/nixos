{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.services.playit;
in {
  options.clan-net.services.playit.enable = lib.mkEnableOption "playit proxy";

  config = lib.mkIf cfg.enable {
    # playit.gg proxy
    environment.systemPackages = [pkgs.playit];
    systemd.services.playit = {
      description = "playit proxy";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        User = "playit";
        Group = "playit";
        Type = "simple";
        ExecStart = "${pkgs.playit}/bin/playit -s";
        Restart = "always";
        RuntimeDirectory = "playit";
        # hardening options
        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        SystemCallFilter = "~@cpu-emulation @keyring @module @obsolete @raw-io @reboot @swap @sync";
      };
    };

    users = {
      groups.playit = {};
      users.playit = {
        group = "playit";
        isSystemUser = true;
      };
    };
  };
}
