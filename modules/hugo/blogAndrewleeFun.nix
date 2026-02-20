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
    services.caddy.virtualHosts."blog.andrewlee.fun" = {
      serverAliases = ["andrewlee.fun"];
      extraConfig = ''
        import cloudflare_mtls
        root * ${static-files}/var/www
        file_server
      '';
    };
  };
}
