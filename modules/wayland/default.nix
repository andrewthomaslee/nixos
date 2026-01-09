{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.clan-net.services.wayland;
in
{
  options.clan-net.services.wayland = {
    enable = mkEnableOption "wayland configuration";
  };

  config = mkIf cfg.enable {
    # Turn on wayland support for some electron apps
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      NIXOS_OZONE_WL = "1";
    };

    # Extra portals (screensharing)
    xdg.portal = {
      enable = true;
      config.common.default = [
        "wlr"
        "gtk"
      ];
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    environment.systemPackages = with pkgs; [
      xdg-desktop-portal
      wdisplays # Configure screen placement
    ];
  };
}
