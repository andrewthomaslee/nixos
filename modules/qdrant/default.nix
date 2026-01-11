{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.services.qdrant;
in {
  options.clan-net.services.qdrant = {
    enable = lib.mkEnableOption "qdrant";
    basePath = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/";
      description = "Path to qdrant storage";
      example = "/mnt/storage/";
    };
  };

  config = lib.mkIf cfg.enable {
    services.qdrant = {
      enable = true;
      settings = {
        storage = {
          hsnw_index = {
            on_disk = true;
          };
        };
        service = {
          host = "127.0.0.1";
          http_port = 6333;
          grpc_port = 6334;
        };
        telemetry_disabled = true;
      };
    };
    systemd.services.qdrant.serviceConfig = {
      # Mounts your external drive folder to the internal state directory
      BindPaths = ["${cfg.basePath}qdrant:/var/lib/qdrant"];
    };
  };
}
