{
  lib,
  config,
  ...
}: let
  cfg = config.clan-net.services.networking.ethernet;

  # TODO: `error: attribute 'facter' missing`
  controllers = config.facter.report.hardware.network_controller;
  ethDevice =
    lib.findFirst
    (dev: dev.model == "Ethernet controller")
    (builtins.head controllers)
    controllers;
  interfaceName = builtins.head ethDevice.unix_device_names;
in {
  options.clan-net.services.networking.ethernet.enable = lib.mkEnableOption "networking ethernet";

  config = lib.mkIf cfg.enable {
    networking.interfaces.${interfaceName} = {
      useDHCP = true;
      wakeOnLan = {
        enable = true;
        policy = ["phy" "unicast" "multicast" "broadcast" "arp" "magic"];
      };
    };
  };
}
