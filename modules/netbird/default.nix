{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.networking.netbird;
in {
  imports = [
    ./clan-net.nix
    ./industrial-host.nix
  ];

  options.clan-net.networking.netbird = {
    enable = lib.mkEnableOption "netbird";
    role = lib.mkOption {
      type = lib.types.enum ["server" "client"];
      default = "server";
      description = "netbird role";
      example = "client";
    };
  };

  config = lib.mkIf cfg.enable {
    services.netbird = {
      enable = true;
      useRoutingFeatures = cfg.role;
    };
  };
}
