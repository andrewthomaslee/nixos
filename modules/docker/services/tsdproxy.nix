{
  clan-facts,
  config,
  lib,
  clan-net-utils,
  ...
}: let
  inherit (clan-net-utils) writeYamlFile;
  cfg = config.clan-net.docker.services.tsdproxy;
  domain = clan-facts.docker.domain;
in {
  options.clan-net.docker.services.tsdproxy.enable = lib.mkEnableOption "tsdproxy";

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.tsdproxy = {
      share = true;
      prompts.auth_key.persist = true;
      files.auth_key = {};
    };

    virtualisation.oci-containers.containers.tsdproxy = let
      authKeyFile = config.clan.core.vars.generators.tsdproxy.files.auth_key.path;
      tsdproxy-config = writeYamlFile "tsdproxy-config.yaml" {
        defaultProxyProvider = "default";
        docker.local = {
          host = "unix:///var/run/docker.sock";
          targetHostname = "fd00::1";
          defaultProxyProvider = "default";
        };
        tailscale = {
          providers.default = {inherit authKeyFile;};
          dataDir = "/data/";
        };
        http = {
          hostname = "0.0.0.0";
          port = 8080;
        };
        log = {
          level = "trace";
          json = false;
        };
        proxyAccessLog = true;
      };
    in {
      serviceName = "tsdproxy-";
      image = "almeidapaulopt/tsdproxy:1";
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "tsdproxy_data:/data"
        "${tsdproxy-config}:/config/tsdproxy.yaml"
        "${authKeyFile}:${authKeyFile}"
      ];
      networks = ["proxy"];
      labels = {
        "tsdproxy.enable" = "true";
        "tsdproxy.name" = "tsdproxy-${builtins.replaceStrings ["."] ["-"] domain}";
        "tsdproxy.container_port" = "8080";
        "traefik.enable" = "true";
        "traefik.http.routers.tsdproxy.rule" = "Host(`tsdproxy.${domain}`)";
        "traefik.http.services.tsdproxy.loadbalancer.server.port" = "8080";
      };
    };
  };
}
