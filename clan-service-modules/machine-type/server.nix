{config, ...}: {
  # Limit log size for journal
  services = {
    journald.extraConfig = "SystemMaxUse=10G";
  };

  clan-net = {
    defaults = {
      environment.enable = true;
      locale.enable = true;
      nix.enable = true;
      storagebox = {
        enable = true;
        mountOnAccess = true;
        boxUser = "u488514-sub1";
      };
    };
    services = {
      openssh.enable = true;
      motd.enable = true;
    };

    virtualisation = {
      docker.enable = true;
    };

    networking = {
      netbird = {
        enable = true;
        role = "server";
        clan-net = {
          enable = true;
          port = 51820;
        };
        # industrial-host = {
        #   enable = true;
        #   port = 51821;
        # };
      };
    };
  };

  # Backup Postgres, if it is running
  services.postgresqlBackup = {
    enable = config.services.postgresql.enable;
    startAt = "*-*-* 01:15:00";
    location = "/var/backup/postgresql";
    backupAll = true;
  };
}
