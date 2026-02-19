{
  config,
  flake-self,
  ...
}: {
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

    networking.tailscale.enable = true;
  };

  # Backup Postgres, if it is running
  services.postgresqlBackup = {
    enable = config.services.postgresql.enable;
    startAt = "*-*-* 01:15:00";
    location = "/var/backup/postgresql";
    backupAll = true;
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.k3s-worker;
  home-manager.users.root = flake-self.homeConfigurations.k3s-worker;
}
