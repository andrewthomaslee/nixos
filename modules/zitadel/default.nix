{
  config,
  lib,
  pkgs,
  clan-facts,
  ...
}: let
  cfg = config.clan-net.services.zitadel;
in {
  options.clan-net.services.zitadel = {
    enable = lib.mkEnableOption "zitadel";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "andrewlee.cloud";
    };
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.zitadel = {
      files = {
        admin_password = {owner = config.services.zitadel.user;};
        master_key = {owner = config.services.zitadel.user;};
        admin_steps = {owner = config.services.zitadel.user;};
        settings = {owner = config.services.zitadel.user;};
      };
      runtimeInputs = with pkgs; [
        coreutils
      ];
      script = ''
        mkdir -p $out

        # Function to generate a random 32-character secret
        generate_secret() {
          ( set +o pipefail ; tr -dc A-Za-z0-9 </dev/urandom | head -c 32 )
        }

        # Generate admin_password
        ADMIN_PASSWORD="$(generate_secret)"
        echo -n "$ADMIN_PASSWORD" > $out/admin_password

        # Generate master_key
        MASTER_KEY="$(generate_secret)"
        echo -n "$MASTER_KEY" > $out/master_key

        # Create admin_steps file
        cat > $out/admin_steps <<EOF
        FirstInstance:
          InstanceName: Zitadel
          Org:
            Human:
              UserName: Admin
              FirstName: Admin
              LastName: Super
              DisplayName: AdminSuper
              Password: $ADMIN_PASSWORD
              PasswordChangeRequired: false
              Email:
                Address: ${clan-facts.email}
                Verified: true
        EOF

        # Create settings file
        cat > $out/settings <<EOF
        Database:
          postgres:
            User:
              Username: zitadel
              Password: $ADMIN_PASSWORD
              SSL:
                Mode: disable
            Admin:
              Username: postgres
              SSL:
                Mode: disable
        EOF
      '';
    };
    # Enable the PostgreSQL backup module
    clan.core.postgresql.enable = true;

    services.zitadel = {
      enable = true;
      openFirewall = true;

      masterKeyFile = config.clan.core.vars.generators.zitadel.files.master_key.path;
      extraStepsPaths = [config.clan.core.vars.generators.zitadel.files.admin_steps.path];
      extraSettingsPaths = [config.clan.core.vars.generators.zitadel.files.settings.path];

      tlsMode = "external";
      settings = {
        Port = 39995;
        ExternalPort = 443;
        ExternalDomain = "auth.${cfg.domain}";
        Database = {
          postgres = {
            Host = "127.0.0.1";
            Port = 5432;
            Database = "zitadel";
            MaxOpenConns = 15;
            MaxIdleConns = 10;
            MaxConnLifetime = "1h";
            MaxConnIdleTime = "5m";
          };
        };
      };
    };
    services.nginx.virtualHosts."auth.${cfg.domain}" = {
      forceSSL = true;
      useACMEHost = cfg.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:39995";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
}
