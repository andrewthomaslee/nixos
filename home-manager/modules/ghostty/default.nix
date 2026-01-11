{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.programs.ghostty;
in {
  options.clan-net.programs.ghostty.enable = lib.mkEnableOption "ghostty";

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "Cyberpunk Scarlet Protocol";
        font-size = 15;
      };
    };
  };
}
