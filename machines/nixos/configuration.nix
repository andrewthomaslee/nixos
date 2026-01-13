{
  config,
  flake-self,
  ...
}: {
  clan-net = {
    services = {
      motd.sshMotd = builtins.readFile ./sshMotd.sh;
      qdrant.enable = true;
      qdrant.basePath = "/mnt/storage/";
    };

    filesystems.ext4.enable = true;
  };

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
}
