{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.clan-net.defaults.environment;
in {
  options.clan-net.defaults.environment = {
    enable = mkEnableOption "Environment defaults";
  };

  config = mkIf cfg.enable {
    # System-wide environment variables to be set
    environment = {
      variables = {
        EDITOR = "codium --wait";
        GOPATH = "/home/netsa/.go";
      };
    };
  };
}
