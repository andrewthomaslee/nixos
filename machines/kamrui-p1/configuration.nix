{
  pkgs,
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
}: {
  clan-net = {
    filesystems.ext4.enable = true;

    services = {
      playit.enable = true;
      minecraft = {
        enable = true;
        fabric = {
          serverVersion = "1_21_11";
          loaderVersion = "0.18.4";
        };
        whitelist = {
          netsammateo = "06c0f83a-7ffe-466c-be19-b3c247b1438c";
          scorch3000 = "1380ccf2-aef4-4cb3-8d18-cf3642dac80c";
          Dingleborf = "0c86d5d5-44f4-4752-ae87-927beaeca0d5";
          GrimpTheImp = "df7a653a-e6d3-4287-84db-e06fb989bb58";
          sapphyy = "7ef1c05d-86b9-49fc-a3cf-ed1918818e2f";
          juwee = "d3dbf932-48dc-4102-b70d-5fbcf3eb1012";
          shinybronzor = "5417dbdb-dbd6-4d15-88e0-3bbd73bd7652";
        };
        symlinks = {
          mods = pkgs.linkFarm "mods" (
            pkgs.lib.mapAttrsToList
            (name: path: {
              name = "${name}.jar";
              inherit path;
            })
            {
              inherit
                # Client + Server
                Fabric-API
                Travelers-Backpack
                Storage-Drawers
                # Server + Optional Client
                Lithium
                Cardinal-Components-API
                Cloth-Config-API
                JEI
                FerriteCore
                Jade
                AppleSkin
                Open-Parties-and-Claims
                Fabric-Config-API-Port
                Vein-Miner
                Vien-Miner-Enchantment
                Silk
                Kotlin
                Clumps
                Distant-Horizons
                Concurrent-Chunk-Management-Engine
                Universal-Shops
                Polymer
                Essential-Commands
                Elytra-Trims
                Dragon-Drops-Elytra
                Collective
                Armored-Elytra
                Bow-Infinity-Fix
                Universal-Enchants
                Puzzles-Lib
                Grind-Enchantments
                Unlimited-Enchantments
                Inventory-Sorting
                ;
            }
          );
        };
      };
    };
  };

  services.tailscale.extraUpFlags = [
    "--advertise-routes=192.168.1.0/24"
  ];

  # Enable GPU acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
