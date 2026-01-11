{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.clan-net.defaults.locale;
in {
  options.clan-net.defaults.locale = {
    enable = mkEnableOption "Locale defaults";
  };

  config = mkIf cfg.enable {
    # Set localization and tty options
    i18n.defaultLocale = "en_US.UTF-8";

    # Set the timezone
    time.timeZone = "America/Chicago";
  };
}
