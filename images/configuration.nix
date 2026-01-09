{
  config,
  pkgs,
  lib,
  modulesPath,
  clan-facts,
  ...
}:
with lib;
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  config = {
    # Filesystems
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    # Bootloader
    boot.growPartition = true;
    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/vda";
    boot.loader.timeout = 0;

    # Locale settings
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "colemak";
    };

    # TODO set hostname
    networking.hostName = "my-nixos-host";

    # Openssh
    programs.ssh.startAgent = false;
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      startWhenNeeded = true;
      kbdInteractiveAuthentication = false;
      permitRootLogin = "yes";
    };

    users.users.root.openssh.authorizedKeys.keys = [ clan-facts.ssh_public_key ];

    # Enable flakes
    nix.package = pkgs.nixVersions.stable;

    # Install some basic utilities
    environment.systemPackages = with pkgs; [
      neovim
      vim
      git
      htop
      httpie
    ];
  };
}
