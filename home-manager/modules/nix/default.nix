{
  config,
  lib,
  ...
}:
let
  cfg = config.clan-net.programs.nix;
in
{
  options.clan-net.programs.nix.enable = lib.mkEnableOption "programs";

  config = lib.mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
