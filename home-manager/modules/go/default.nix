{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.clan-net.programs.go;
in {
  options.clan-net.programs.go.enable = mkEnableOption "go compiler";

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GOPATH = "/home/${config.home.username}/.go";
    };
    programs.go = {
      enable = true;
      env.GOPATH = "/home/${config.home.username}/.go";
    };
  };
}
