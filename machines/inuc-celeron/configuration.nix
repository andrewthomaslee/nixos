{pkgs, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    # kubernetes host
    kubernetes.k3s = {
      enable = false;
      manager.enable = true;
      config.cilium.enable = true; # TODO: make traefik ingress option
      services = {
        traefik.enable = true;
      };
    };

    services = {
      # static website hosting
      hugo = {
        enable = true;
        blogAndrewleeFun.enable = true; # https://blog.andrewlee.fun
      };

      jellyfin.ingress.enable = true; # TODO: make this genric Caddy ingress
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
