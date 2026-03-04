{pkgs, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    # kubernetes host
    kubernetes.k3s = {
      enable = true;
      manager.enable = true;
      config.cilium.enable = true;
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };
}
