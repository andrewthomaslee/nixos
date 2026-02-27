{config, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    services = {
      motd.sshMotd = builtins.readFile ./sshMotd.sh;
    };

    virtualisation = {
      virtualbox.enable = true;
    };
  };
  jovian.steam = {
    enable = true;
    autoStart = true;
    user = "netsa";
    desktopSession = "plasma";
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
  # To build raspi images
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
