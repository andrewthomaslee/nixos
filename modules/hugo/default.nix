{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.services.hugo;
in {
  imports = [
    ./blogAndrewleeFun.nix
  ];

  options.clan-net.services.hugo.enable = lib.mkEnableOption "Hugo";

  config = lib.mkIf cfg.enable {
    clan-net.services.caddy.enable = lib.mkDefault true;
  };
}
