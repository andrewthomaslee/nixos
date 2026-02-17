{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.docker;
in {
  imports = [./services];

  options.clan-net.docker.enable = lib.mkEnableOption "Docker Containers";

  config = lib.mkIf cfg.enable {
    virtualisation = {
      oci-containers.backend = "docker";
      docker = {
        enable = true;
        logDriver = "json-file";
        listenOptions = [
          "/run/docker.sock"
          "0.0.0.0:2375"
        ];
        daemon.settings = {
          fixed-cidr-v6 = "fd00::/80";
          ipv6 = true;
        };
        autoPrune.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      docker-vackup
    ];
  };
}
