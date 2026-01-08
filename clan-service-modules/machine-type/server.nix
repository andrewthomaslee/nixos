{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  # Limit log size for journal
  services.journald.extraConfig = "SystemMaxUse=5G";

  environment.systemPackages = with pkgs; [
    git
    neovim
    vim
  ];

  clan-net = {
    defaults = {
      environment.enable = true;
      locale.enable = true;
      nix.enable = true;
      storagebox = {
        enable = true;
        mountOnAccess = true;
        boxUser = "u488514-sub1";
        boxPath = "/u488514-sub1";
      };
    };
    services = {
      openssh.enable = true;
      tailscale.enable = true;
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
