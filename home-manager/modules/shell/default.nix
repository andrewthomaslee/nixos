{
  config,
  lib,
  ...
}:
let
  cfg = config.clan-net.defaults.shell;
in
{
  imports = [
    ./starship.nix
    ./bash.nix
  ];

  options.clan-net.defaults.shell.enable = lib.mkEnableOption "shell defaults";

  config = lib.mkIf cfg.enable {
    programs = {
      ripgrep.enable = true;
      eza.enable = true;
      zoxide.enable = true;
      fzf.enable = true;
      yazi.enable = true;
    };
  };
}
