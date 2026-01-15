{
  config,
  lib,
  pkgs,
  blogAndrewleeFun,
  ...
}: let
  cfg = config.clan-net.services.hugo.blogAndrewleeFun;
  static-files = blogAndrewleeFun.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  options.clan-net.services.hugo.blogAndrewleeFun.enable = lib.mkEnableOption "blog.andrewlee.fun";

  config = lib.mkIf cfg.enable {
    services.nginx = {
      virtualHosts."blog.andrewlee.fun" = {
        forceSSL = true;
        useACMEHost = "andrewlee.fun";
        root = "${static-files}/var/www";
      };
    };
  };
}
