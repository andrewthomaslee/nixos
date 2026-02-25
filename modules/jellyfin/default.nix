{
  config,
  lib,
  clan-facts,
  ...
}: let
  cfg = config.clan-net.services.jellyfin;
  net = clan-facts.networking.tailscale.IPv4;
in {
  options.clan-net.services.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";
    host = lib.mkOption {
      type = lib.types.str;
      default = "kamrui-p1";
      description = "jellyfin host";
    };
    ingress.enable = lib.mkEnableOption "jellyfin ingress";
  };

  config = lib.mkIf (cfg.enable || cfg.ingress.enable) {
    services.caddy.virtualHosts = lib.optionalAttrs cfg.ingress.enable {
      "jellyfin.andrewlee.cloud".extraConfig = ''
        import cloudflare_mtls
        reverse_proxy ${net.${cfg.host}}:8096
      '';
    };

    services.jellyfin = lib.optionalAttrs cfg.enable {
      enable = true;
      openFirewall = true;
      hardwareAcceleration = {
        enable = true;
        type = "vaapi";
        device = "/dev/dri/renderD128";
      };
      transcoding = {
        throttleTranscoding = true;
        threadCount = 6;
        enableHardwareEncoding = true;
        enableToneMapping = true;
        hardwareEncodingCodecs.hevc = true;
        hardwareDecodingCodecs = {
          av1 = true;
          vp9 = true;
          hevc = true;
          hevcRExt12bit = true;
          hevcRExt10bit = true;
          hevc10bit = true;
          h264 = true;
        };
      };
    };
  };
}
