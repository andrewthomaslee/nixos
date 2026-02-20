{
  config,
  pkgs,
  lib,
  clan-facts,
  ...
}: let
  cfg = config.clan-net.networking.tailscale;
in {
  options.clan-net.networking.tailscale = {
    enable = lib.mkEnableOption "tailscale";
    systray = lib.mkEnableOption "systray";
    baseURL = lib.mkOption {
      type = lib.types.str;
      default = "https://controlplane.tailscale.com";
      description = "Tailscale base URL";
      example = "https://headscale.my-domain.com";
    };
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.tailscale = {
      share = true;
      prompts.auth_key = {};
      files.auth_key = {};
      files.vpn-auth-file = {};
      script = ''
        mkdir -p $out
        cp $prompts/auth_key $out/auth_key
        echo "name=tailscale,joinKey=$(cat $prompts/auth_key)" > $out/vpn-auth-file
      '';
    };

    services.tailscale = {
      enable = true;
      package = pkgs.tailscale;
      openFirewall = true;
      permitCertUid = clan-facts.email;
      authKeyFile = config.clan.core.vars.generators.tailscale.files.auth_key.path;
      authKeyParameters = {
        ephemeral = false;
        preauthorized = true;
        inherit (cfg) baseURL;
      };
      useRoutingFeatures = "server";
      extraSetFlags = [
        "--advertise-exit-node"
      ];
    };
    networking = {
      networkmanager.unmanaged = ["tailscale0"];
      firewall = {
        trustedInterfaces = ["tailscale0"];
        checkReversePath = "loose";
      };
    };
    services.networkd-dispatcher = {
      enable = true;
      rules."50-tailscale" = {
        onState = ["routable"];
        script = ''
          #!${pkgs.runtimeShell}
          NETDEV=$(${pkgs.iproute2}/bin/ip -o route get 8.8.8.8 | cut -f 5 -d " ")
          ${pkgs.ethtool}/bin/ethtool -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };

    systemd.services.tailscaled-autoconnect = {
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
        StartLimitIntervalSec = 0;
      };
      unitConfig = {
        StartLimitIntervalSec = 0; # Unlimited retries
      };
    };

    systemd.user.services.tailscale-systray = lib.mkIf cfg.systray {
      enable = true;
      description = "Tailscale Systray GUI";
      after = [
        "graphical-session.target"
        "tailscaled.service"
      ];
      wants = ["tailscaled.service"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStart = ''${pkgs.tailscale}/bin/tailscale systray'';
      };
    };
  };
}
