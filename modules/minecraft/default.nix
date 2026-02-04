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
              # ------ Client+Server mods ------#
              Fabric-API = fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/i5tSkVBH/fabric-api-0.141.3%2B1.21.11.jar";
                sha512 = "c20c017e23d6d2774690d0dd774cec84c16bfac5461da2d9345a1cd95eee495b1954333c421e3d1c66186284d24a433f6b0cced8021f62e0bfa617d2384d0471";
              };
              StorageDrawers = fetchurl {
                url = "https://cdn.modrinth.com/data/guitPqEi/versions/Q9r8LMQL/StorageDrawers-fabric-1.21.11-20.0.0.jar";
                sha512 = "504acbcd06cd567d0793ada189d8995426743a458947253f8b2f0344d88fe0ddf7efdd86a4ffcbfc91b800dbe6d1113962b56aa3c5c21d0594d323c608f0f7e7";
              };
              Travelers-Backpack = fetchurl {
                url = "https://cdn.modrinth.com/data/rlloIFEV/versions/jDSDEMgY/travelersbackpack-fabric-1.21.11-10.11.5.jar";
                sha512 = "06ce904071582935bfb206fd071fcd20e968edb72a151ab677c6763b85497c19327ff5d24575ceaec510a517fb14f05bda660cfdf06cea3f5d6b9ff28fd9a903";
              };
              # ------ Server-side mods ------#
              Lithium = fetchurl {
                url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/gl30uZvp/lithium-fabric-0.21.2%2Bmc1.21.11.jar";
                sha512 = "94625510013e0daaf1c2e2b6d8a463c932ff6220f91ba5b0cd5f868658215f046d94d07b3465660f576c4dc27a5aa183dfbdc1c9303f11894b5b25a1dc6c3bb6";
              };
              Cardinal-Components-API = fetchurl {
                url = "https://cdn.modrinth.com/data/K01OU20C/versions/tEsBSUgb/cardinal-components-api-7.3.0.jar";
                sha512 = "ec93427bef05b6c198d7cc20270b81edc72a7b117ed87c96b0324fef10383ed994dddb21d9814d581737e0ab35a278d9e43d53d25722d8b70e1e47c9628d978a";
              };
              Cloth-Config-API = fetchurl {
                url = "https://cdn.modrinth.com/data/9s6osm5g/versions/xuX40TN5/cloth-config-21.11.153-fabric.jar";
                sha512 = "8f455489d4b71069e998568cf4e1450116f4360a4eb481cd89117f629c6883164886cf63ca08ac4fc929dd13d1112152755a6216d4a1498ee6406ef102093e51";
              };
              JEI = fetchurl {
                url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/N7YozqFm/jei-1.21.11-fabric-27.4.0.15.jar";
                sha512 = "b5d0153a1f312f124fa7fd9ff7dd8ec4f572bea9e2a42025d8fd2b4f1e5714f246c635476afb4e27d4bbe83d69b693af6de7db2616eef761366ba6927e459b6a";
              };
              FerriteCore = fetchurl {
                url = "https://cdn.modrinth.com/data/uXXizFIs/versions/Ii0gP3D8/ferritecore-8.2.0-fabric.jar";
                sha512 = "3210926a82eb32efd9bcebabe2f6c053daf5c4337eebc6d5bacba96d283510afbde646e7e195751de795ec70a2ea44fef77cb54bf22c8e57bb832d6217418869";
              };
              Jade = fetchurl {
                url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/HKUAgY3D/Jade-1.21.11-Fabric-21.1.1.jar";
                sha512 = "566a7cf3fa17a8170dcdc52a61d9965bc7848a7b503ecf3b18a7e3caa617f28a77a1d6787ac4e49ac30436d235c8ff01f67e92771546a0b319b34392a47b0baf";
              };
              AppleSkin = fetchurl {
                url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/59ti1rvg/appleskin-fabric-mc1.21.11-3.0.8.jar";
                sha512 = "d32206cb8d6fac7f0b579f7269203135777283e1639ccb68f8605e9f5469b5b54305fd36ba82c64b48b89ae4f1a38501bfb5827284520c3ec622d95edcfa34de";
              };
              Open-Parties-and-Claims = fetchurl {
                url = "https://cdn.modrinth.com/data/gF3BGWvG/versions/xE2Whg8K/open-parties-and-claims-fabric-1.21.11-0.25.8.jar";
                sha512 = "4a1a225b446f2f9b605e73a6703f5b6427e45a130f87c15d3877533d191df01da20ea691c469dca74c9d2f2f09c5e7b9a2156e94c12cad1d856d1ff9eda6d2f3";
              };
              Fabric-Config-API-Port = fetchurl {
                url = "https://cdn.modrinth.com/data/ohNO6lps/versions/uXrWPsCu/ForgeConfigAPIPort-v21.11.1-mc1.21.11-Fabric.jar";
                sha512 = "28791c992d613da14b8685505d3ef632ed53b5f1e1d517f0b41677d10f8419f192dfbde991308df6cda5d0f113c0aa8fc18ecf4a0834029403b16d2f68dc52d6";
              };
              VeinMiner = fetchurl {
                url = "https://cdn.modrinth.com/data/OhduvhIc/versions/SMDUhqTN/veinminer-fabric-2.5.2.jar";
                sha512 = "965d6766b53b81cba52067fd1040a8b7e6410173245b030cb15b8aecde3e78fdf29facfd754fbd27b84f734ea33b7a80bb16691dbdcdbcccba60773fa445d7a0";
              };
              VienMiner-Enchantment = fetchurl {
                url = "https://cdn.modrinth.com/data/4sP0LXxp/versions/h5oKcjvq/veinminer-enchant-2.3.0.jar";
                sha512 = "151ddfbf7e9d56a964083497cc28e38a4c311cd9fbf43bb6ab7ee6ef6cb0fa11ef977d1244062d6343d5acb1b8b3ebfe2e87f00c9e5e4ffc9a4a06edbf04b65b";
              };
              Silk = fetchurl {
                url = "https://cdn.modrinth.com/data/aTaCgKLW/versions/tgYliGAU/silk-all-1.11.5.jar";
                sha512 = "23c31d044aae5ea7946d819f304af820dd06bf37f2516c2f24ef3c1f7b1e0bc1096b8b8abb67144936c92c9b8ef4953a6004da3ddb8d52a4ab44ab33c6c2865d";
              };
              Kotlin = fetchurl {
                url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/N6D3uiZF/fabric-language-kotlin-1.13.8%2Bkotlin.2.3.0.jar";
                sha512 = "90bf59f810ea62363bdd7b2ce85a6268b7db67d6d4ce5ae6555204bc7eff0446a6e17d60ef51ad41bf85e92ca430043a8f7c21157cbaee9279733304605cc4d0";
              };
              Clumps = fetchurl {
                url = "https://cdn.modrinth.com/data/Wnxd13zP/versions/OgBE8Rz4/Clumps-fabric-1.21.11-29.0.0.1.jar";
                sha512 = "3cff3cd2d600a6d84030b38ce6244143d13774d5287627bb7312adae5edc7ae2d9151a2c9c39a00681c354d549b0a62ac48c0077ba586cc10c00d32f39e87f18";
              };
              Distant-Horizons = fetchurl {
                url = "https://cdn.modrinth.com/data/uCdwusMi/versions/GT3Bm3GN/DistantHorizons-2.4.5-b-1.21.11-fabric-neoforge.jar";
                sha512 = "a9f673fac1f6f554b7394168cbe726f1a15eb2bbef1b65b3c9979853af8de70bf13a457c88ebdc30b955a071d519e86c631cdbf1dd39cdab7c73b9c2d7f165e1";
              };
              Concurrent-Chunk-Management-Engine = fetchurl {
                url = "https://cdn.modrinth.com/data/VSNURh3q/versions/olrVZpJd/c2me-fabric-mc1.21.11-0.3.6.0.0.jar";
                sha512 = "c9b11100572fb71c3080ff11b011467624e8013b9942aade09a5c77eb62b3289667bad70501ddea8f35deb0a5d26884b79f76d4ed112d32342471ca7384b788a";
              };
              Universal-Shops = fetchurl {
                url = "https://cdn.modrinth.com/data/cnIatHrN/versions/M6PTvMlM/universal_shops-1.13.0%2B1.21.11.jar";
                sha512 = "4139eedd9ebe49452cc38f95851778e5e27ead069c163bd5507aaa2194ec1e2b16f754178f3f3e9cd741dd3b4ff178aeeda4a2c29477c90adfc5556780107aca";
              };
              Polymer = fetchurl {
                url = "https://cdn.modrinth.com/data/xGdtZczs/versions/wugBT1fU/polymer-bundled-0.15.2%2B1.21.11.jar";
                sha512 = "9c205ab398c324ee4dc376269d8aa5df64d11766b6418952a64d2df94f096e665f63eae0c4f0c66e22d03c6ff6767550d1777c28485340131e6556091199062a";
              };
              Essential-Commands = fetchurl {
                url = "https://cdn.modrinth.com/data/6VdDUivB/versions/3s9XXmZa/essential_commands-0.38.6-mc1.21.11.jar";
                sha512 = "3bbe9a7a63e97189308bf907057c6c766f60f799f9830a791048c604df1f994cf7cebc0de5d9e703ef9586fc7b65e8386942976529dd72522243ac7be1e3113b";
              };
              Elytra-Trims = fetchurl {
                url = "https://cdn.modrinth.com/data/XpzGz7KD/versions/Nzd1iQCn/elytratrims-fabric-4.6.2%2B1.21.11.jar";
                sha512 = "085ac9a491d1451f589a47e2c8d5fc726014bf98cc2b03179aeae1fcf0d9421b2c2ab9f0e8b4efe770284a09537c86e44b7b29597a237e22351cb1c357603ff9";
              };
              Dragon-Drops-Elytra = fetchurl {
                url = "https://cdn.modrinth.com/data/DPkbo3dg/versions/NwRksTCY/dragondropselytra-1.21.11-3.5.jar";
                sha512 = "45126bc7a9091416c8349e347ad9155db9d96c50a54dbdeec8c765f07e95e4cd994694ba1c5897cd5f970c67fc7fb53190dede4cb89c9218a233753f9a329c82";
              };
              Armored-Elytra = fetchurl {
                url = "https://cdn.modrinth.com/data/AuFCCYMx/versions/mKCSekSL/armored-elytra-1.12.0.jar";
                sha512 = "aca0712908aa99a20e440c87737fddfbc38cfede7d71bbdb5b7e27f47f606cbd0094725fd8cde1f93037adfa65c8234ffc982295f959d827ad9b7fce474ba931";
              };
              Bow-Infinity-Fix = fetchurl {
                url = "https://cdn.modrinth.com/data/BFENfScW/versions/besCdt3U/BowInfinityFix-1.21.9-fabric-3.1.2.jar";
                sha512 = "95740611709d6090c6e8741ef1c65762f812906d4120f857f1e5862d7aa14c55810eb6aacea918e354eb7a00668c263d244b508b6bd6e4cc6b13c3637b4918f9";
              };
              Universal-Enchants = fetchurl {
                url = "https://cdn.modrinth.com/data/DT56YDir/versions/MuPwsQLB/UniversalEnchants-v21.11.2-mc1.21.11-Fabric.jar";
                sha512 = "8b3a0f310a7f657ac787824d50e9372b07a55bc184be5efb396af9b9267a842909105b472e403d77cbfb6d3db29609c29292eb5b4e2db49dd1207ce559b7d433";
              };
              Puzzles-Lib = fetchurl {
                url = "https://cdn.modrinth.com/data/QAGBst4M/versions/7L1WGsjw/PuzzlesLib-v21.11.6-mc1.21.11-Fabric.jar";
                sha512 = "2e555c6537b6d0cecaa8947e3c94935cd87a6eae4243bc92beb122a8d039ba9d735645b0d69e083f7875403e3139b1c21d36b8db0aa5a07c3b361fa61a835811";
              };
              Grind-Enchantments = fetchurl {
                url = "https://cdn.modrinth.com/data/WC4UgDcZ/versions/XX0LqtxX/grind-enchantments-4.1.0%2B1.21.11-pre2.jar";
                sha512 = "55538e5041515100b608722f83c8e6e22f9b9102995b6c4c305db749f754c69e50db4907d8d9ffec8861ec85ea5f171da73916e2e465bb3dea38d872579bf4f6";
              };
              Unlimited-Enchantments = fetchurl {
                url = "https://cdn.modrinth.com/data/6YplFU9p/versions/b0x3rZY5/unlimited-enchantments-1.1.1%2B1.21.X.jar";
                sha512 = "afb5724f92a40266f2afaa8f45c8c0ffcaf85dc1ff8afcd2509bf97d465ccfdb9962325f2dab5be5aea3018a7d33ef8ca345d8396916e1248b7b2b5db33b1f05";
              };
              Inventory-Sorting = fetchurl {
                url = "https://cdn.modrinth.com/data/5ibSyLAz/versions/Dq4h9aTH/inventorysorter-fabric-2.1.4%2Bmc1.21.11.jar";
                sha512 = "a3ea975d76a7073f98eb5ccb47360e48e4ce2eab44b32b1ec720ce870f0e296958f17ecb7c13a3397671d637cc92e022e7b6e978e4cd30a2ee64b09d308358c5";
              };
            }
          );
        };
      };
    };
  };
}
