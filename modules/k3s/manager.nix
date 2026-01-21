{
  config,
  lib,
  clan-facts,
  ...
}: let
  cfg = config.clan-net.services.k3s;
  net = clan-facts.machines.${config.networking.hostName}.networking;
  k3s = clan-facts.k3s;
in {
  config = lib.mkIf cfg.manager {
    environment.etc = {
      "rancher/k3s/registries.yaml".text = ''
        mirrors:
          "*":
      '';
    };

    # K3s
    services.k3s = {
      role = "server";
      disable = ["traefik"];
      nodeLabel = ["role=manager"];
      extraFlags = [
        "--embedded-registry"
        "--cluster-cidr=${k3s.cluster-cidr.IPv4}"
        "--service-cidr=${k3s.service-cidr.IPv4}"
        "--flannel-backend=wireguard-native"
        "--flannel-iface=${net.interface}"
      ];
    };
  };
}
