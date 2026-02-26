{
  config,
  lib,
  clan-facts,
  pkgs,
  ...
}: let
  cfg = config.clan-net.kubernetes.k3s;
  hostName = config.networking.hostName;
  init = clan-facts.k3s.init;
  net = clan-facts.networking.public;
  privateIPv4 = net.IPv4.${hostName};
  initIPv4 = net.IPv4.${init};
in {
  imports = [
    ./services
    ./worker.nix
    ./manager.nix
  ];

  options.clan-net.kubernetes.k3s = {
    enable = lib.mkEnableOption "k3s";
    clusterInit = lib.mkEnableOption "Initialize cluster";
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.k3s = lib.optionalAttrs (!cfg.clusterInit) {
      share = true;
      prompts.token.persist = true;
      files.token = {};
    };

    # private-registry
    environment.etc."rancher/k3s/registries.yaml" = {
      text = ''
        mirrors:
          "*":
      '';
    };

    # k3s
    services.k3s = {
      enable = true;
      package = pkgs.k3s_1_35;
      nodeLabel = ["host=${hostName}"];
      tokenFile =
        if cfg.clusterInit
        then null
        else config.clan.core.vars.generators.k3s.files.token.path;
      serverAddr =
        if cfg.clusterInit
        then ""
        else "https://${initIPv4}:6443";
      nodeIP = privateIPv4;
      extraFlags = [
        "--node-external-ip=${privateIPv4}"
      ];
    };

    boot.kernel.sysctl = {
      # enable ip forwarding
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv4.conf.all.forwarding" = 1;
    };

    networking = let
      interfaces = ["tailscale0" "flannel+" "cali+" "tunl+" "vxlan.calico" "vxlan-v6.calico" "wireguard.cali" "wg-v6.calico" "cilium" "cilium*" "cilium+" "cil+" "cil*" "cni*" "lxc+" "lxc*"];
    in {
      networkmanager.unmanaged = interfaces;
      firewall = {
        enable = lib.mkForce false;
        trustedInterfaces = interfaces;
        allowPing = true; # Covers Port 8/0 ICMP
        allowedTCPPorts = [
          6443 # Kubernetes API
          5001 # embedded distributed registry
          10250 # kubelet metrics
        ];
        allowedUDPPorts = [
          8472 # Flannel VXLAN
          51820 # Flannel Wireguard with IPv4
          51821 # Flannel Wireguard with IPv6
        ];
        # node port range
        allowedTCPPortRanges = [
          {
            from = 30000;
            to = 32767;
          }
        ];
      };
    };
  };
}
