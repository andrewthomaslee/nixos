{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.clan-net.programs.python;
in
{
  options.clan-net.programs.python.enable = lib.mkEnableOption "python";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      python314
    ];
    programs.uv = {
      enable = true;
      settings = {
        python-downloads = "never";
        python-preference = "only-system";
        link-mode = "copy";
      };
    };
  };
}
