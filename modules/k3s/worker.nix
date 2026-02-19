{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.kubernetes.k3s.worker;
in {
  options.clan-net.kubernetes.k3s.worker.enable = lib.mkEnableOption "Control plane node";

  config = lib.mkIf cfg.enable {
    # k3s
    services.k3s = {
      role = "agent";
      nodeLabel = ["role=worker"];
    };
  };
}
