{pkgs, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    # kubernetes host
    kubernetes.k3s = {
      enable = false;
      worker.enable = true;
      services = {
        traefik.enable = true;
        longhorn.enable = true;
      };
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
