{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.docker.services.dockhand;
  domain = "andrewlee.fun";
in {
  options.clan-net.docker.services.dockhand.enable = lib.mkEnableOption "dockhand";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.dockhand = {
      serviceName = "dockhand";
      image = "fnsys/dockhand:latest";
      pull = "always";
      ports = ["3000:3000"];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "dockhand_data:/app/data"
      ];
      networks = ["proxy"];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.dockhand.rule" = "Host(`dockhand.${domain}`)";
        "traefik.http.routers.dockhand.entrypoints" = "websecure";
        "traefik.http.routers.dockhand.tls" = "true";
        "traefik.http.routers.dockhand.tls.options" = "cloudflare-mtls@file";
        "traefik.http.services.dockhand.loadbalancer.server.port" = "3000";
      };
    };
  };
}
