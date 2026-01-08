{
  lib,
  config,
  clan-facts,
  ...
}: let
  net = clan-facts.machines.${config.networking.hostName}.networking;
  cfg = config.clan-net.hetzner.cloud;
in {
  options.clan-net.hetzner.cloud.enable = lib.mkEnableOption "Hetzner Cloud Settings";

  config = lib.mkIf cfg.enable {
    networking = {
      defaultGateway6 = {
        address = net.IPv6.gateway;
        inherit (net) interface;
      };
      # Public Interface
      interfaces.${net.interface} = {
        ipv6.addresses = [
          {
            inherit (net.IPv6) address prefixLength;
          }
        ];
      };
    };
  };
}
