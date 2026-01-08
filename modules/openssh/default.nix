{
  config,
  pkgs,
  lib,
  clan-facts,
  ...
}:
with lib; let
  cfg = config.clan-net.services.openssh;
in {
  options.clan-net.services.openssh = {
    enable = mkEnableOption "OpenSSH server";
  };

  config = mkIf cfg.enable {
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # Block anything that is not HTTP(s) or SSH.
    networking.firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [22];
    };

    users.users.root.openssh.authorizedKeys.keyFiles = [clan-facts.ssh_public_key];
  };
}
