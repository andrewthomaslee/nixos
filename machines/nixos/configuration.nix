{config, ...}: {
  clan-net = {
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = false;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };
  boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidiafb" "nvidia_drm"];
}
