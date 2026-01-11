{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.clan-net.defaults.fonts;
in {
  options.clan-net.defaults.fonts = {
    enable = mkEnableOption "Fonts defaults";
  };

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        stix-two
        league-of-moveable-type
        inter
        source-sans-pro
        source-serif-pro
        noto-fonts-monochrome-emoji
        # corefonts
        recursive
        iosevka-bin
        font-awesome
        line-awesome
      ];

      fontconfig = {
        defaultFonts = {
          serif = [
            "Berkeley Mono"
            "Inconsolata Nerd Font Mono"
          ];
          sansSerif = [
            "Berkeley Mono"
            "Inconsolata Nerd Font Mono"
          ];
          monospace = [
            "Berkeley Mono"
            "Inconsolata Nerd Font Mono"
          ];
          emoji = ["Noto Emoji"];
        };
      };
    };
  };
}
