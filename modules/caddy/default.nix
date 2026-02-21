{
  config,
  lib,
  pkgs,
  ...
}: let
  cloudflare-ca = pkgs.fetchurl {
    url = "https://developers.cloudflare.com/ssl/static/authenticated_origin_pull_ca.pem";
    sha256 = "0hxqszqfzsbmgksfm6k0gp0hsx9k1gqx24gakxqv0391wl6fsky1";
  };
  cfg = config.clan-net.services.caddy;
in {
  options.clan-net.services.caddy.enable = lib.mkEnableOption "caddy";

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.caddy = let
      prompt_settings = {
        persist = true;
        type = "multiline";
        description = ''
          Cert & Key
        '';
        display.group = "caddy";
      };
      file_settings = {
        owner = "caddy";
        group = "caddy";
      };
    in {
      share = true;
      prompts = {
        "ai-providers.net.pem" = prompt_settings;
        "frfropen.ai.pem" = prompt_settings;
        "andrewlee.cloud.pem" = prompt_settings;
        "andrewlee.fun.pem" = prompt_settings;
      };
      files = {
        "ai-providers.net.pem" = file_settings;
        "frfropen.ai.pem" = file_settings;
        "andrewlee.cloud.pem" = file_settings;
        "andrewlee.fun.pem" = file_settings;
      };
    };
    # move the certs to /etc/certs
    systemd.services.caddy = {
      serviceConfig = {
        PermissionsStartOnly = true;
        ExecStartPre = let
          caddy-prestart = pkgs.writeShellApplication {
            name = "caddy-prestart";
            runtimeInputs = [pkgs.rsync pkgs.coreutils];
            text = ''
              mkdir -p /etc/certs
              rsync -a --delete /var/run/secrets/vars/caddy/ /etc/certs/
              chown -R caddy:caddy /etc/certs
              chmod 700 /etc/certs
              chmod 400 /etc/certs/*
            '';
          };
        in
          lib.mkBefore [
            "${caddy-prestart}/bin/caddy-prestart"
          ];
      };
    };
    services.caddy = {
      enable = true;
      # Enforce mTLS with Cloudflare and TLS 1.3
      extraConfig = ''
        (cloudflare_mtls) {
          tls {
            load /etc/certs
            client_auth {
              mode require_and_verify
              trust_pool file {
                pem_file ${cloudflare-ca}
              }
            }
            protocols tls1.3
            curves x25519 secp256r1 secp384r1
          }
          header Strict-Transport-Security "max-age=63072000"
        }
      '';
    };
    networking.firewall.allowedTCPPorts = [443];

    environment.systemPackages = with pkgs; [
      goaccess
    ];
  };
}
