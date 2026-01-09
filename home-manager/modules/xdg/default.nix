{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.clan-net.defaults.xdg;
in
{
  options.clan-net.defaults.xdg = {
    enable = mkEnableOption "xdg defaults";
  };

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      configFile = { };
    };
  };
}
