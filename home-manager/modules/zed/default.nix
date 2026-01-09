{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.clan-net.programs.zed;
in
{
  options.clan-net.programs.zed = {
    enable = mkEnableOption "Zed editor configuration";
  };

  config = mkIf cfg.enable {
    # Add nixd (Nix language server) for better Nix support
    home.packages = with pkgs; [
      nixd
    ];

    programs.zed-editor = {
      enable = true;
      extensions = [ "nix" ];
      userSettings = {
        telemetry = {
          metrics = false;
          diagnostics = false;
        };
        vim_mode = false;
        ui_font_size = 15;
        buffer_font_size = 15;
        buffer_font_family = "Berkeley Mono";
        ui_font_family = "Berkeley Mono";
        theme = {
          mode = "dark";
          light = "Ayu Light";
          dark = "One Dark";
        };
        language_overrides = {
          nix = {
            language_server_id = "nixd";
          };
        };
      };
    };
  };
}
