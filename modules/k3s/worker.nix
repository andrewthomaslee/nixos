{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.services.k3s;
in {
  config = lib.mkIf cfg.worker {
    # K3s
    services.k3s = {
      role = "agent";
      nodeLabel = ["role=worker"];
    };
  };
}
