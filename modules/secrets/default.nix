{
  lib,
  config,
  clan-net-utils,
  ...
}: let
  inherit (clan-net-utils) mkPasswordHashGenerator;
  cfg = config.clan-net.secrets;
in {
  options.clan-net.secrets.enable = lib.mkEnableOption "Enable password and hash secrets";

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.middleware-admin = mkPasswordHashGenerator "admin";
    clan.core.vars.generators.middleware-user = mkPasswordHashGenerator "user";
  };
}
