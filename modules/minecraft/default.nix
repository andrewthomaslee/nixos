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
      package = pkgs.minecraft-server;
      enable = true;
      eula = true;
      declarative = true;
      openFirewall = true;
      serverProperties = {
        level-seed = config.clan.core.vars.generators.minecraft.files.seed.value;
        gamemode = "survival";
        difficulty = "hard";
        simulation-distance = "12";
        motd = "NixOS Minecraft server!";
        white-list = true;
        enforce-whitelist = true;
        force-gamemode = true;
      };
      whitelist = {
        netsammateo = "06c0f83a-7ffe-466c-be19-b3c247b1438c";
        scorch3000 = "1380ccf2-aef4-4cb3-8d18-cf3642dac80c";
        Dingleborf = "0c86d5d5-44f4-4752-ae87-927beaeca0d5";
        GrimpTheImp = "df7a653a-e6d3-4287-84db-e06fb989bb58";
        sapphyy = "7ef1c05d-86b9-49fc-a3cf-ed1918818e2f";
      };
      inherit (cfg) jvmOpts;
    };
  };
}
