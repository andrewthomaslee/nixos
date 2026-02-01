{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.services.minecraft;
in {
  options.clan-net.services.minecraft = {
    enable = lib.mkEnableOption "Minecraft";
    jvmOpts = lib.mkOption {
      type = lib.types.str;
      default = "-Xms4G -Xmx16G -XX:+UseG1GC -XX:ParallelGCThreads=12 -XX:+DisableExplicitGC";
      description = "JVM Options";
      example = lib.literalExpression ''
        "-Xms4G -Xmx16G -XX:+UseG1GC -XX:ParallelGCThreads=12 -XX:+DisableExplicitGC"
      '';
    };
    whitelist = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Whitelisted players";
      example = lib.literalExpression ''
        {
          netsammateo = "06c0f83a-7ffe-466c-be19-b3c247b1438c";
          sapphyy = "7ef1c05d-86b9-49fc-a3cf-ed1918818e2f";
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.minecraft = {
      prompts = {
        seed = {
          description = "world seed";
          display.group = "minecraft";
        };
      };
      files = {
        seed.secret = false;
      };
      runtimeInputs = [pkgs.coreutils];
      script = ''
        mkdir -p $out
        cp $prompts/* $out/
      '';
    };
    # Minecraft
    services.minecraft-server = {
      enable = true;
      eula = true;
      package = pkgs.minecraft-server;
      declarative = true;
      openFirewall = true;
      serverProperties =
        {
          level-seed = config.clan.core.vars.generators.minecraft.files.seed.value;
          gamemode = "survival";
          difficulty = "hard";
          simulation-distance = "12";
          motd = "❄️ NixOS Minecraft ⛏️";
          force-gamemode = true;
        }
        // lib.optionalAttrs (cfg.whitelist != {}) {
          white-list = true;
          enforce-whitelist = true;
        };
      inherit (cfg) jvmOpts whitelist;
    };

    # playit.gg proxy
    environment.systemPackages = [pkgs.playit];
  };
}
