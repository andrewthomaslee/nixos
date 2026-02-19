{
  pkgs,
  lib,
  flake-self,
  ...
}: {
  services = {
    fwupd.enable = true;
    acpid.enable = true;
    journald.extraConfig = "SystemMaxUse=1G";
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
      fonts.enable = true;
      locale.enable = true;
      nix.enable = true;
      sound.enable = true;
    };

    services = {
      wayland.enable = true;
      motd.enable = true;
    };

    networking.tailscale = {
      enable = true;
      systray = true;
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
    usbutils
  ];

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.desktop;
  home-manager.users.root = flake-self.homeConfigurations.desktop;

  boot.tmp.useTmpfs = false;
}
