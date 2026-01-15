{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.services.nginx;
in {
  options.clan-net.services.nginx = {
    enable = lib.mkEnableOption "Nginx";
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      enableQuicBPF = true;
      recommendedUwsgiSettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      enableReload = true;
    };
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
