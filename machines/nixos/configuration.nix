{
  config,
  flake-self,
  uv2nix-template,
  ...
}: {
  imports = [
    uv2nix-template.nixosModules.oci
  ];

  clan-net = {
    filesystems.ext4.enable = true;

    services = {
      motd.sshMotd = builtins.readFile ./sshMotd.sh;
      netbird.enable = true;
    };

    virtualisation = {
      docker.enable = true;
      virtualbox.enable = true;
    };
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.desktop;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidiafb"
    "nvidia_drm"
  ];
  # To build raspi images
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
