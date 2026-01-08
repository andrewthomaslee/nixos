{
  config,
  flake-self,
  ...
}: {
  clan-net = {
    filesystems.ext4.enable = true;
  };

  home-manager.users.madi = flake-self.homeConfigurations.desktop;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidiafb" "nvidia_drm"];
}
