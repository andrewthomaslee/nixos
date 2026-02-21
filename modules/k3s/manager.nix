{
  config,
  pkgs,
  clan-facts,
  lib,
  ...
}: let
  cfg = config.clan-net.kubernetes.k3s.manager;
  kube = clan-facts.k3s;
in {
  options.clan-net.kubernetes.k3s.manager.enable = lib.mkEnableOption "Control plane node";

  config = lib.mkIf cfg.enable {
    # kubeconfig
    environment.variables = {
      KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };

    # k3s
    services.k3s = {
      role = "server";
      nodeLabel = ["role=manager"];
      disable = ["servicelb"];
      extraFlags = [
        "--cluster-cidr=${kube.cluster-cidr.IPv4}"
        "--service-cidr=${kube.service-cidr.IPv4}"
        "--flannel-backend=vxlan"
      ];
    };
  };
}
