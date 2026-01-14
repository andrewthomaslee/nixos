{
  pkgs,
  lib,
  ...
}: {
  services.fwupd.enable = true;
  services.acpid.enable = true;

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
      tailscale = {
        enable = true;
        systray = true;
      };
      motd.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
    usbutils
    wget
  ];

  services.logind.settings.Login.RuntimeDirectorySize = "10G";

  boot.tmp.useTmpfs = false;
}
