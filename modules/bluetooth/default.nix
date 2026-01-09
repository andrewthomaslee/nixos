{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.clan-net.defaults.bluetooth;
in
{
  options.clan-net.defaults.bluetooth = {
    enable = mkEnableOption "default bluetooth configuration";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}
