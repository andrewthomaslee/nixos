{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.clan-net.programs.firefox;
in
{
  options.clan-net.programs.firefox.enable = mkEnableOption "firefox browser";

  config = mkIf cfg.enable {
    # Browserpass
    programs.browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
    };
  };
}
