{
  config,
  pkgs,
  clan-facts,
  clan-net-utils,
  lib,
  ...
}: let
  inherit (clan-net-utils) mkPasswordHashGenerator;
  cfg = config.clan-net.kubernetes.k3s.manager;
  kube = clan-facts.k3s;
in {
  options.clan-net.kubernetes.k3s.manager.enable = lib.mkEnableOption "Control plane node";

  config = lib.mkIf cfg.enable {
    # generate password and hash for k3s admin middleware and other services
    clan.core.vars.generators.password-and-hash = mkPasswordHashGenerator "admin";
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
        "--embedded-registry"
        "--cluster-cidr=${kube.cluster-cidr.IPv4},${kube.cluster-cidr.IPv6}"
        "--service-cidr=${kube.service-cidr.IPv4},${kube.service-cidr.IPv6}"
      ];
    };
  };
}
