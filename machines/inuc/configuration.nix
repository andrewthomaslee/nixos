{pkgs, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    # kubernetes host
    kubernetes.k3s = {
      enable = true;
      worker.enable = true;
      config.cilium.enable = true;
      services = {
        traefik.enable = true;
      };
    };

    services = {
      # static website hosting
      hugo = {
        enable = true;
        blogAndrewleeFun.enable = true; # https://andrewlee.fun
      };

      jellyfin.ingress.enable = true;
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
