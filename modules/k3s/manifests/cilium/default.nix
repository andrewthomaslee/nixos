{
  config,
  lib,
  clan-net-utils,
  clan-facts,
  ...
}: let
  inherit (clan-net-utils) writeYamlFile;
  cfg = config.clan-net.kubernetes.cluster;
in {
  options.clan-net.kubernetes.cluster = {
    name = lib.mkOption {
      type = lib.types.str;
    };
    id = lib.mkOption {
      type = lib.types.str;
    };
    serverAddr = lib.mkOption {
      type = lib.types.str;
    };
    clusterCidr = {
      ipv4 = lib.mkOption {
        type = lib.types.str;
      };
      ipv6 = lib.mkOption {
        type = lib.types.str;
      };
    };
    serviceCidr = {
      ipv4 = lib.mkOption {
        type = lib.types.str;
      };
      ipv6 = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config.services.k3s = {
    extraFlags = [
      "--tls-san=${cfg.serverAddr}"
      "--flannel-backend=none"
      "--disable-network-policy"
      "--disable-kube-proxy"
    ];
    manifests.cilium.source = writeYamlFile "cilium.yaml" {
      apiVersion = "helm.cattle.io/v1";
      kind = "HelmChart";
      metadata = {
        name = "cilium";
        namespace = "kube-system";
      };
      spec = {
        bootstrap = true;
        repo = "https://helm.cilium.io/";
        chart = "cilium";
        version = "1.19.1";
        targetNamespace = "kube-system";
        valuesContent = lib.generators.toYAML {} {
          MTU = 1350;
          devices = "wireguard";
          operator.replicas = 1;
          kubeProxyReplacement = true;
          k8sServiceHost = cfg.serverAddr;
          k8sServicePort = "6443";

          ipv4.enabled = true;
          ipv6.enabled = true;
        };
      };
    };
  };
}
