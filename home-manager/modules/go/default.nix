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
    programs = {
      go = {
        enable = true;
        env.GOPATH = "/home/netsa/.go";
      };
    };
  };
}
