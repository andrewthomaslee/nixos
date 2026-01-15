{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.clan-net.services.postgres;
in {
  options.clan-net.services.postgres.enable = lib.mkEnableOption "Postgres";

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.postgres = {
      files.password = {owner = "postgres";};
      runtimeInputs = with pkgs; [
        coreutils
      ];
      script = ''
        mkdir -p $out

        # Function to generate a random 32-character secret
        generate_secret() {
          ( set +o pipefail ; tr -dc A-Za-z0-9 </dev/urandom | head -c 32 )
        }

        # Generate postgres_password
        POSTGRES_PASSWORD="$(generate_secret)"
        echo -n "$POSTGRES_PASSWORD" > $out/password
      '';
    };

    clan.core.postgresql.enable = true;
    systemd.services.postgresql = {
      serviceConfig.ExecStartPost = lib.mkAfter [
        "${config.services.postgresql.package}/bin/psql -c \"ALTER USER postgres WITH PASSWORD '$(${pkgs.coreutils}/bin/cat ${config.clan.core.vars.generators.postgres.files.password.path})';\""
      ];
    };
  };
}
