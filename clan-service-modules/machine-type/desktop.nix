{
  config,
  pkgs,
  lib,
  flake-self,
  home-manager,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  services.fwupd.enable = true;
  services.acpid.enable = true;

  # To build raspi images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Enable networkmanager
  networking.networkmanager.enable = true;

  # Often hangs
  systemd.services = {
    NetworkManager-wait-online.enable = lib.mkForce false;
    systemd-networkd-wait-online.enable = lib.mkForce false;
  };

  # DON'T set useGlobalPackages! It's not necessary in newer
  # home-manager versions and does not work with configs using
  # nixpkgs.config`
  home-manager.useUserPackages = true;

  # Backup files before overwriting them with home-manager
  home-manager.backupFileExtension = "hm-backup";

  # Pass all flake inputs to home-manager modules aswell so we can use them
  # there.
  # home-manager.extraSpecialArgs = flake-self.inputs;
  home-manager.extraSpecialArgs = {
    inherit flake-self;

    # Pass system configuration (top-level "config") to home-manager modules,
    # so we can access it's values for conditional statements. Writing is NOT possible!
    system-config = config;
  };

  nixpkgs.overlays = [
    flake-self.overlays.default
  ];

  # TODO parametrize the username
  home-manager.users.netsa = flake-self.homeConfigurations.desktop;

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

    virtualisation = {
      docker.enable = true;
      virt-manager.enable = true;
      virtualbox.enable = false;
    };

    services = {
      wayland.enable = true;
      openssh.enable = true;
      tailscale = {
        enable = true;
        systray = true;
      };
      networking.enable = true;
      motd.enable = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    firefox
    git
    neovim
    vim
    ripgrep
    usbutils
    wget
  ];

  services.logind.settings.Login.RuntimeDirectorySize = "20G";

  boot = {
    # Use GRUB2 as EFI boot loader.
    loader.grub.useOSProber = true;
    tmp.useTmpfs = false;
  };
}
