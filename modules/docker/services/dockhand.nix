{
  config,
  lib,
  clan-facts,
  ...
}: let
  cfg = config.clan-net.docker.services.dockhand;
  domain = clan-facts.docker.domain;
in {
  options.clan-net.docker.services.dockhand.enable = lib.mkEnableOption "dockhand";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.dockhand = {
      serviceName = "dockhand";
      image = "fnsys/dockhand:latest";
      pull = "always";
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "dockhand_data:/app/data"
      ];
      networks = ["proxy"];
      labels = {
        "tsdproxy.enable" = "true";
        "tsdproxy.name" = "dockhand-${builtins.replaceStrings ["."] ["-"] domain}";
        "tsdproxy.container_port" = "3000";
        "traefik.enable" = "true";
        "traefik.http.routers.dockhand.rule" = "Host(`dockhand.${domain}`)";
        "traefik.http.services.dockhand.loadbalancer.server.port" = "3000";
      };
    };
  };
}
