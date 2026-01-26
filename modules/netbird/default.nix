{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.networking.netbird;

  # Submodule definition
  netbirdNetworkOpts = {
    name,
    config,
    ...
  }: {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable this specific netbird network.";
      };
      ui.enable = lib.mkEnableOption "netbird ui for this network";
      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = null;
        description = "Port for this interface. If null, it auto-increments starting at 51820 based on alphabetical order.";
      };
    };
  };
in {
  options.clan-net.networking.netbird = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule netbirdNetworkOpts);
    default = {};
    description = "Map of netbird networks to configure.";
  };

  config = let
    # Get all interface names and sort them alphabetically to ensure deterministic port assignment
    sortedNames = lib.sort (a: b: a < b) (lib.attrNames cfg);

    # Helper to calculate port or use manual override
    getPort = name: index:
      if cfg.${name}.port != null
      then cfg.${name}.port
      else 51820 + index;

    indexedNames =
      lib.lists.imap0 (index: name: {
        inherit index name;
      })
      sortedNames;

    enabledNames = lib.filter (n: cfg.${n}.enable) sortedNames;

    forEachEnabled = f:
      lib.concatMap ({
        index,
        name,
      }:
        if cfg.${name}.enable
        then f index name
        else [])
      indexedNames;
  in {
    services.netbird.enable = lib.mkIf (cfg != {}) true;

    clan.core.vars.generators.netbird = {
      share = lib.mkIf (enabledNames != []) true;
      prompts = lib.listToAttrs (forEachEnabled (_: name: [
        (lib.nameValuePair "${name}-setup_key" {persist = true;})
      ]));
      files = lib.listToAttrs (forEachEnabled (_: name: [
        (lib.nameValuePair "${name}-setup_key" {})
      ]));
    };

    services.netbird.clients = lib.listToAttrs (forEachEnabled (index: name: [
      (lib.nameValuePair name {
        ui.enable = cfg.${name}.ui.enable;
        port = getPort name index;
        interface = name;
        login = {
          enable = true;
          setupKeyFile = config.clan.core.vars.generators.netbird.files."${name}-setup_key".path;
        };
      })
    ]));

    systemd.services = lib.listToAttrs (forEachEnabled (_: name: [
      (lib.nameValuePair "netbird-${name}-login" {
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = "5s";
          StartLimitIntervalSec = 0;
        };
        unitConfig = {
          StartLimitIntervalSec = 0;
        };
      })
    ]));

    networking = {
      networkmanager.unmanaged = enabledNames;
      firewall = {
        trustedInterfaces = enabledNames;
        checkReversePath = lib.mkIf (enabledNames != []) "loose";
      };
    };
  };
}
