{
  config,
  pkgs,
  lib,
  clan-net-utils,
  ...
}: let
  inherit (clan-net-utils) mkPasswordHashGenerator mkEnvGenerator;
  cfg = config.clan-net.secrets.traefik.andrewlee-fun;
  domain = "andrewlee.fun";

  # cloudflare client auth ca
  cloudflare-ca = pkgs.fetchurl {
    url = "https://developers.cloudflare.com/ssl/static/authenticated_origin_pull_ca.pem";
    sha256 = "0hxqszqfzsbmgksfm6k0gp0hsx9k1gqx24gakxqv0391wl6fsky1";
  };
in {
  options.clan-net.secrets.traefik.andrewlee-fun.enable = lib.mkEnableOption "Enable Traefik secrets";

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators = {
      # middleware password and hash
      middleware-andrewlee-fun-admin = mkPasswordHashGenerator "admin";
      middleware-andrewlee-fun-user = mkPasswordHashGenerator "user";
      # cloudflared tunnel
      cloudflared-andrewlee-fun = mkEnvGenerator ["TUNNEL_TOKEN"];
      # wildcard tls cert from cloudflare
      traefik-andrewlee-fun = {
        share = true;
        prompts = {
          "${domain}.crt" = {
            description = "TLS Certificate for ${domain}";
            display.group = "TLS";
            type = "multiline";
            persist = true;
          };
          "${domain}.key" = {
            description = "TLS Key for ${domain}";
            display.group = "TLS";
            type = "multiline";
            persist = true;
          };
        };
        files = {
          "${domain}.key" = {};
          "${domain}.crt" = {};
          "cloudflare-ca.pem".mode = "0444";
        };
        script = ''
          mkdir -p $out
          cp ${cloudflare-ca} $out/cloudflare-ca.pem
        '';
      };
    };
  };
}
