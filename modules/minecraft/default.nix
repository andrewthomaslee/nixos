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
      default = "-Xms8G -Xmx8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";
      description = "JVM Options";
      example = lib.literalExpression ''
        "-Xms4G -Xmx4G -XX:+UseG1GC -XX:ParallelGCThreads=4 -XX:+DisableExplicitGC"
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
      package = pkgs.papermc.override {jre = pkgs.jdk21_headless;};
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
  };
}
