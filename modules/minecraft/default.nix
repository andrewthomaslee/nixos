{
  pkgs,
  config,
  lib,
  nix-minecraft,
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
        package = pkgs.fabricServers.fabric-1_21_1.override {
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

        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" (
            builtins.attrValues {
              Fabric-API = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/tV4Gc0Zo/fabric-api-0.138.4%2B1.21.10.jar";
                sha512 = "5e64c53391dfd1c059777d671c52be17a4e27a29d9bd7340ea9e3f55ce7a770b38db0a15e0966e981ee8c1b9372fb89543a278521624689268acebb85bd5c6e9";
              };
              Travelers-Backpack = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/rlloIFEV/versions/uQ0xHxTz/travelersbackpack-fabric-1.21.10-10.10.6.jar";
                sha512 = "f646cd21479f78a6032473cc63fbfcb8885778494d0aa877fe8b6be18d945c2c8e1ab99b1145cad1d346e1d19e9124837026f715f1a4b8fb0c8ce94418af23eb";
              };
              Cloth-Config-API = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/9s6osm5g/versions/qMxkrrmq/cloth-config-20.0.149-fabric.jar";
                sha512 = "df1d9e0349dc64fc0859f17b65b67b0d7745a26b4905e87fc148ddebc0285de51a3255848599f0d5ee24f6aab00fbac4849d40bb9052936eaa452d216c7ada62";
              };
              Cardinal-Components-API = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/K01OU20C/versions/LfKjIXlt/cardinal-components-api-7.2.0.jar";
                sha512 = "17f774748496ab1ad90172b9fda68a15033a94c7eac1ca1d7c78444a8eef3b38dad9694baf21fa6b1d3fc9a95095b974707ccc4b74f283455d8c09a7216d6f5c";
              };
              JEI = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/Y0JKqg8L/jei-1.21.10-fabric-26.2.0.30.jar";
                sha512 = "f6172be28d689fc92ab53de255ab542d635c5c69ba6808d4b710733d5027ba88da0932906a5e93cece980b0661d809fea44013316c293fb084db76bda1cd8388";
              };
              FerriteCore = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/uXXizFIs/versions/bPLllEgi/ferritecore-8.1.0-fabric.jar";
                sha512 = "0596c83d69867380260e20500e5ab184415a1178317464c2b7c8c68a87db435fbe7a80b22b4f50b56558d6506f7dbb35ad7bda16f46eab5b79d38f0d726f08f5";
              };
              Jade = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/qC0qUqL5/Jade-1.21.9-Fabric-20.0.5.jar";
                sha512 = "4039ae3f6126abcf715db667cfb66ba18d17ee820824b9a86a62cba4a2e9e663d1423b7a7a10b265618caf733daa91d75226332cdce9056e65eadae4f912a05b";
              };
              AppleSkin = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/8sbiz1lS/appleskin-fabric-mc1.21.9-3.0.7.jar";
                sha512 = "79d0d0b4a09140cdb7cf74b1cd71554147c60648beb485ca647b149174e171660ec561ad329da58b78b5de439909b180e287b4b38bf068acfca20666100f4584";
              };
              Open-Parties-and-Claims = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/gF3BGWvG/versions/MZ9uI929/open-parties-and-claims-fabric-1.21.10-0.25.8.jar";
                sha512 = "bb9ef8c3a4503f990d484820c8d4c93c0a5d5e5603fffafbb5e2b575d24889ed198bf48024fcec8d482279c0639a8de3d2b5a3c463f3203fe6b03f9546e80267";
              };
              Fabric-Config-API-Port = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/ohNO6lps/versions/IKHTwwTv/ForgeConfigAPIPort-v21.10.1%2Bmc1.21.10-Fabric.jar";
                sha512 = "ecb322db9e2c1a0cec8fb06300e1568847980f336fe77f3dda16a89a73da59cbf2152e3ffb2337ad9019dc6bd247a7534e6046e8fd93a3cdb6de065a24093ab9";
              };
              JourneyMap = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/lfHFW1mp/versions/K1m5OFRZ/journeymap-fabric-1.21.10-6.0.0-beta.55.jar";
                sha512 = "001c86558707c23d525e0c68b681d89af855bf13473ae07316b6e73f5da37e796f4e9697aeed45a475a8d838fa2474693c590ce9eefd10cf603c457c1fec6919";
              };
            }
          );
        };
      };
    };
  };
}
