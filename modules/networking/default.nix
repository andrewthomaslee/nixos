{
  lib,
  config,
  clan-facts,
  ...
}:
with lib; let
  cfg = config.clan-net.services.networking;
in {
  options.clan-net.services.networking.enable = mkEnableOption "networking";

  config = mkIf cfg.enable {
    networking.interfaces.${clan-facts.machines.${config.networking.hostName}.networking.interface} = {
      useDHCP = true;
      wakeOnLan.enable = true;
    };
  };
}
