{
  config,
  lib,
  clan-net-utils,
  gatewayclasses,
  gateways,
  httproutes,
  referencegrants,
  grpcroutes,
  tlsroutes,
  ...
}: let
  inherit (clan-net-utils) writeYamlFile;
  cfg = config.clan-net.kubernetes.cilium;
in {
  options.clan-net.kubernetes.cilium = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "default";
    };
    id = lib.mkOption {
      type = lib.types.int;
      default = 0;
    };
    k8sServiceHost = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
    };
    clusterCidr = {
      ipv4 = lib.mkOption {
        type = lib.types.str;
        default = "10.42.0.0/16";
      };
      ipv6 = lib.mkOption {
        type = lib.types.str;
        default = "fd42::/56";
      };
    };
  };

  config = {
    # networking
    networking = let
      interfaces = ["cilium+" "lxc+"];
    in {
      networkmanager.unmanaged = interfaces;
      firewall = {
        checkReversePath = "loose";
        trustedInterfaces = interfaces;
      };
    };
    # k3s
    services.k3s = lib.mkIf (config.services.k3s.role == "server") {
      extraFlags = [
        "--tls-san=${cfg.k8sServiceHost}"
        "--flannel-backend=none"
        "--disable-network-policy"
        "--disable-kube-proxy"
      ];
      manifests = {
        gatewayclasses.source = gatewayclasses;
        gateways.source = gateways;
        httproutes.source = httproutes;
        referencegrants.source = referencegrants;
        grpcroutes.source = grpcroutes;
        tlsroutes.source = tlsroutes;
        cilium.source = writeYamlFile "cilium.yaml" {
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
              cluster = {
                inherit (cfg) name id;
              };

              MTU = 1350;
              devices = "wireguard";
              operator.replicas = 1;
              kubeProxyReplacement = true;
              k8sServiceHost = cfg.k8sServiceHost;
              k8sServicePort = "6443";

              ipv4.enabled = true;
              ipv6.enabled = true;

              ipam = {
                mode = "cluster-pool";
                operator = {
                  clusterPoolIPv4PodCIDRList = [cfg.clusterCidr.ipv4];
                  clusterPoolIPv6PodCIDRList = [cfg.clusterCidr.ipv6];
                };
              };

              hubble = {
                enabled = true;
                relay.enabled = true;
                ui.enabled = true;
              };

              gatewayAPI = {
                enabled = true;
                enableAlpn = true;
                hostNetwork.enabled = true;
                gatewayClass.create = "false";
              };
              envoy = {
                enabled = true;
                securityContext.capabilities = {
                  keepCapNetBindService = true;
                  envoy = ["NET_BIND_SERVICE" "NET_ADMIN" "SYS_ADMIN"];
                };
              };
            };
          };
        };
      };
    };
  };
}
