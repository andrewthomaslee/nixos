{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.clan-net.programs.taskwarrior;
in {
  options.clan-net.programs.taskwarrior.enable = mkEnableOption "takswarrior configuration";

  config = mkIf cfg.enable {
    programs.taskwarrior = {
      package = pkgs.taskwarrior3;
      enable = true;
    };
  };
}
