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
          storage_path = "${cfg.basePath}qdrant/storage";
          snapshots_path = "${cfg.basePath}qdrant/snapshots";
        };
        hsnw_index = {
          on_disk = true;
        };
        service = {
          host = "127.0.0.1";
          http_port = 6333;
          grpc_port = 6334;
        };
        telemetry_disabled = true;
      };
    };
  };
}
