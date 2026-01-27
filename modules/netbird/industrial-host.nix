{
  config,
  lib,
  pkgs,
  ...
}: let
  name = "industrial-host";
  cfg = config.clan-net.networking.netbird.${name};
in {
  options.clan-net.networking.netbird.${name} = {
    enable = lib.mkEnableOption "netbird";
    ui.enable = lib.mkEnableOption "netbird ui";
    port = lib.mkOption {
      type = lib.types.int;
      description = "netbird port";
      example = 51820;
    };
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.netbird = {
      share = true;
      prompts."${name}-setup_key".persist = true;
      files."${name}-setup_key" = {};
    };

    services.netbird = {
      clients.${name} = {
        inherit (cfg) port;
        ui.enable = cfg.ui.enable;
        interface = name;
        login = {
          enable = true;
          setupKeyFile = config.clan.core.vars.generators.netbird.files."${name}-setup_key".path;
        };
      };
    };

    networking.firewall.trustedInterfaces = [name];

    systemd.services."netbird-${name}" = {
      after = ["network-online.target"];
      wants = ["network-online.target"];
    };

    systemd.services."netbird-${name}-login" = {
      after = ["network-online.target" "netbird-${name}.service"];
      wants = ["network-online.target"];
      serviceConfig = {
        StateDirectory = "netbird-${name}";
        ExecStart = lib.mkForce (
          (pkgs.writeShellApplication {
            name = "netbird-${name}-login-start";
            runtimeInputs = [pkgs.netbird pkgs.gnugrep pkgs.gnused pkgs.coreutils];
            text = ''
              export NB_CONFIG='/var/lib/netbird-${name}/config.json'
              export NB_DAEMON_ADDR='unix:///var/run/netbird-${name}/sock'
              export NB_INTERFACE_NAME='${name}'
              export NB_LOG_FILE='console'
              export NB_LOG_LEVEL='info'
              export NB_SERVICE='netbird-${name}'
              export NB_STATE_DIR='/var/lib/netbird-${name}'
              export NB_WIREGUARD_PORT='${toString cfg.port}'

              status_file="/tmp/status.txt"

              refresh_status() {
                netbird status &>"$status_file" || :
              }

              print_short_setup_key() {
                cut -b1-8 <"$NB_SETUP_KEY_FILE"
              }

              echo "Waiting for NetBird daemon and network..."
              # Wait for a definitive state: either we are truly connected to management OR we definitely need to login.
              # We check for 'Management: Connected' specifically to avoid matching '0/0 Connected' peers.
              until refresh_status && grep -qE 'Management: Connected|NeedsLogin' "$status_file"; do
                sleep 2
              done

              # Log the status for debugging
              sed 's/^/STATUS: /' "$status_file"

              if grep -q 'NeedsLogin' "$status_file"; then
                echo "Using Setup Key File with key: $(print_short_setup_key)" >&2
                netbird up --setup-key-file="$NB_SETUP_KEY_FILE"
              fi
            '';
          })
          + "/bin/netbird-${name}-login-start"
        );
      };
    };
  };
}
