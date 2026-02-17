{
  pkgs,
  config,
  lib,
  clan-net-utils,
  ...
}: let
  inherit (clan-net-utils) writeYamlFile;
  cfg = config.clan-net.docker.services.traefik;
  domain = "andrewlee.fun";
in {
  options.clan-net.docker.services.traefik.enable = lib.mkEnableOption "traefik";

  config = lib.mkIf cfg.enable {
    systemd.services.traefik.preStart = lib.mkAfter ''
      ${pkgs.docker}/bin/docker network inspect proxy >/dev/null 2>&1 || ${pkgs.docker}/bin/docker network create proxy
    '';

    virtualisation.oci-containers.containers.traefik = let
      # traefik certs
      cloudflare-ca = config.clan.core.vars.generators.traefik-andrewlee-fun.files."cloudflare-ca.pem".path;
      keyFile = config.clan.core.vars.generators.traefik-andrewlee-fun.files."${domain}.key".path;
      certFile = config.clan.core.vars.generators.traefik-andrewlee-fun.files."${domain}.crt".path;
      # traefik dynamic config
      dynamic-config = writeYamlFile "dynamic.yaml" {
        http.middlewares = {
          basic-auth-admin.basicAuth.users = [
            "${lib.trim config.clan.core.vars.generators.middleware-andrewlee-fun-admin.files.hash.value}"
          ];
          basic-auth-user.basicAuth.users = [
            "${lib.trim config.clan.core.vars.generators.middleware-andrewlee-fun-user.files.hash.value}"
          ];
        };

        tls = {
          certificates = [
            {
              inherit certFile keyFile;
            }
          ];
          options.cloudflare-mtls = {
            minVersion = "VersionTLS12";
            clientAuth = {
              clientAuthType = "RequireAndVerifyClientCert";
              caFiles = [
                cloudflare-ca
              ];
            };
          };
        };
      };
      # traefik static config
      static-config = writeYamlFile "traefik.yaml" {
        api = {
          dashboard = true;
          insecure = false;
        };

        ping.entryPoint = "traefik";

        entryPoints = {
          traefik.address = ":8080";
          websecure = {
            asdefault = true;
            address = ":443";
            http.tls.options = "cloudflare-mtls@file";
          };
        };

        certificatesResolvers.ts.tailscale = {};

        providers = {
          docker = {
            exposedByDefault = false;
            network = "proxy";
          };
          file = {
            filename = dynamic-config;
            watch = false;
          };
        };

        log.level = "DEBUG";
        accessLog = {};
        metrics.prometheus = {};
      };
    in {
      serviceName = "traefik";
      image = "traefik:v3.6.8";
      pull = "always";
      extraOptions = [
        "--health-cmd=traefik healthcheck --ping"
        "--health-interval=30s"
        "--health-timeout=5s"
        "--health-retries=3"
        "--health-start-period=5s"
      ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "traefik_data:/data/"
        "${static-config}:/etc/traefik/traefik.yaml:ro"
        "${dynamic-config}:${dynamic-config}:ro"
        "${cloudflare-ca}:${cloudflare-ca}:ro"
        "${certFile}:${certFile}:ro"
        "${keyFile}:${keyFile}:ro"
      ];
      ports = [
        "443:443"
        "8080:8080"
      ];
      networks = ["proxy"];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.dashboard.rule" = "Host(`docker.${domain}`)";
        "traefik.http.routers.dashboard.service" = "api@internal";
      };
    };

    virtualisation.oci-containers.containers.whoami = {
      serviceName = "whoami";
      image = "traefik/whoami";
      networks = ["proxy"];
      pull = "always";
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.whoami.rule" = "Host(`whoami.${domain}`)";
        "traefik.http.services.whoami.loadbalancer.server.port" = "80";
      };
    };
  };
}
