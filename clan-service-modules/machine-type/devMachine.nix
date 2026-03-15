{
  lib,
  flake-self,
  ...
}: {
  services = {
    fwupd.enable = true;
    acpid.enable = true;
  };

  # Often hangs
  systemd.services = {
    NetworkManager-wait-online.enable = lib.mkForce false;
    systemd-networkd-wait-online.enable = lib.mkForce false;
  };

  # Hardware accelleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  clan-net = {
    defaults = {
      bluetooth.enable = true;
      environment.enable = true;
      storagebox = {
        enable = true;
        mountOnAccess = true;
      };
      fonts.enable = true;
      locale.enable = true;
      nix.enable = true;
      sound.enable = true;
    };

    services = {
      wayland.enable = true;
      openssh.enable = true;
      motd.enable = true;
    };

    networking.tailscale = {
      enable = true;
      systray = true;
    };

    virtualisation.docker.enable = true;
  };

  # Enable sudo without password
  security.sudo.wheelNeedsPassword = false;

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.devMachine;
  home-manager.users.root = flake-self.homeConfigurations.devMachine;

  services.logind.settings.Login.RuntimeDirectorySize = "10G";

  boot.tmp.useTmpfs = false;
}
