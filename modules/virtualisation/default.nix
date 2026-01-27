{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.clan-net.virtualisation;
in {
  options.clan-net.virtualisation = {
    docker.enable = mkEnableOption "Docker virtualisation";
    virtualbox.enable = mkEnableOption "VirtualBox virtualisation";
  };

  config = mkMerge [
    (mkIf cfg.docker.enable {
      users.users.netsa.extraGroups = ["docker"];
      virtualisation = {
        oci-containers.backend = "docker";
        docker = {
          enable = true;
          logDriver = "json-file";
          daemon.settings = {
            fixed-cidr-v6 = "fd00::/80";
            ipv6 = true;
            live-restore = true;
          };
          autoPrune.enable = true;
        };
      };

      environment.systemPackages = with pkgs; [
        docker-vackup
      ];
    })

    (mkIf cfg.virtualbox.enable {
      users.extraGroups.vboxusers.members = ["netsa"];
      virtualisation.virtualbox.host.enable = true;
      # virtualisation.virtualbox.host.enableKvm = true;
      # virtualisation.virtualbox.host.addNetworkInterface = false;
      # virtualisation.virtualbox.host.enableExtensionPack = true;
    })
  ];
}
