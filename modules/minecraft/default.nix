{
  pkgs,
  config,
  lib,
  nix-minecraft,
  Fabric-API,
  Storage-Drawers,
  Travelers-Backpack,
  Lithium,
  Cardinal-Components-API,
  Cloth-Config-API,
  JEI,
  FerriteCore,
  Jade,
  AppleSkin,
  Open-Parties-and-Claims,
  Fabric-Config-API-Port,
  Vein-Miner,
  Vien-Miner-Enchantment,
  Silk,
  Kotlin,
  Clumps,
  Distant-Horizons,
  Concurrent-Chunk-Management-Engine,
  Universal-Shops,
  Polymer,
  Essential-Commands,
  Elytra-Trims,
  Dragon-Drops-Elytra,
  Collective,
  Armored-Elytra,
  Bow-Infinity-Fix,
  Universal-Enchants,
  Puzzles-Lib,
  Grind-Enchantments,
  Unlimited-Enchantments,
  Inventory-Sorting,
  ...
}: let
  cfg = config.clan-net.services.minecraft;
in {
  imports = [
    nix-minecraft.nixosModules.minecraft-servers
    {
      nixpkgs.overlays = [nix-minecraft.overlay];
    }
  ];

  options.clan-net.services.minecraft = {
    enable = lib.mkEnableOption "Minecraft";
    jvmOpts = lib.mkOption {
      type = lib.types.str;
      default = "-Xms8G -Xmx8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1";
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
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers.fabric = {
        enable = true;

        # Specify the custom minecraft server package
        package = pkgs.fabricServers.fabric-1_21_11.override {
          loaderVersion = "0.18.4";
        }; # Specific fabric loader version

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

        symlinks = with pkgs; {
          mods = linkFarmFromDrvs "mods" (
            builtins.attrValues {
            }
          );
        };
      };
    };
  };
}
