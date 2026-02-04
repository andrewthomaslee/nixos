{
  description = "andrewthomaslee's nixos (inspired by github.com/pinpox/nixos )";

  inputs = {
    # Clan.lol
    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";

    # Rolling Release of Nixpkgs from Clan.lol
    nixpkgs.follows = "clan-core/nixpkgs";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- Flakes --- #
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- My Flakes --- #
    moscripts = {
      url = "github:andrewthomaslee/moscripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blogAndrewleeFun = {
      url = "git+https://github.com/andrewthomaslee/blog.andrewlee.fun.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix-template = {
      url = "git+https://github.com/andrewthomaslee/uv2nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    playit = {
      url = "https://github.com/playit-cloud/playit-agent/releases/download/v0.17.1/playit-linux-amd64";
      flake = false;
    };

    # Modded Minecraft Server
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Fabric Mods
    # ------ Client+Server mods ------#
    Fabric-API = {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/i5tSkVBH/fabric-api-0.141.3%2B1.21.11.jar";
      flake = false;
    };
    Storage-Drawers = {
      url = "https://cdn.modrinth.com/data/guitPqEi/versions/Q9r8LMQL/StorageDrawers-fabric-1.21.11-20.0.0.jar";
      flake = false;
    };
    Travelers-Backpack = {
      url = "https://cdn.modrinth.com/data/rlloIFEV/versions/jDSDEMgY/travelersbackpack-fabric-1.21.11-10.11.5.jar";
      flake = false;
    };
    # ------ Server-side mods ------#
    Lithium = {
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/gl30uZvp/lithium-fabric-0.21.2%2Bmc1.21.11.jar";
      flake = false;
    };
    Cardinal-Components-API = {
      url = "https://cdn.modrinth.com/data/K01OU20C/versions/tEsBSUgb/cardinal-components-api-7.3.0.jar";
      flake = false;
    };
    Cloth-Config-API = {
      url = "https://cdn.modrinth.com/data/9s6osm5g/versions/xuX40TN5/cloth-config-21.11.153-fabric.jar";
      flake = false;
    };
    JEI = {
      url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/N7YozqFm/jei-1.21.11-fabric-27.4.0.15.jar";
      flake = false;
    };
    FerriteCore = {
      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/Ii0gP3D8/ferritecore-8.2.0-fabric.jar";
      flake = false;
    };
    Jade = {
      url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/HKUAgY3D/Jade-1.21.11-Fabric-21.1.1.jar";
      flake = false;
    };
    AppleSkin = {
      url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/59ti1rvg/appleskin-fabric-mc1.21.11-3.0.8.jar";
      flake = false;
    };
    Open-Parties-and-Claims = {
      url = "https://cdn.modrinth.com/data/gF3BGWvG/versions/xE2Whg8K/open-parties-and-claims-fabric-1.21.11-0.25.8.jar";
      flake = false;
    };
    Fabric-Config-API-Port = {
      url = "https://cdn.modrinth.com/data/ohNO6lps/versions/uXrWPsCu/ForgeConfigAPIPort-v21.11.1-mc1.21.11-Fabric.jar";
      flake = false;
    };
    Vein-Miner = {
      url = "https://cdn.modrinth.com/data/OhduvhIc/versions/SMDUhqTN/veinminer-fabric-2.5.2.jar";
      flake = false;
    };
    Vein-Miner-Enchantment = {
      url = "https://cdn.modrinth.com/data/4sP0LXxp/versions/h5oKcjvq/veinminer-enchant-2.3.0.jar";
      flake = false;
    };
    Silk = {
      url = "https://cdn.modrinth.com/data/aTaCgKLW/versions/tgYliGAU/silk-all-1.11.5.jar";
      flake = false;
    };
    Kotlin = {
      url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/N6D3uiZF/fabric-language-kotlin-1.13.8%2Bkotlin.2.3.0.jar";
      flake = false;
    };
    Clumps = {
      url = "https://cdn.modrinth.com/data/Wnxd13zP/versions/OgBE8Rz4/Clumps-fabric-1.21.11-29.0.0.1.jar";
      flake = false;
    };
    Distant-Horizons = {
      url = "https://cdn.modrinth.com/data/uCdwusMi/versions/GT3Bm3GN/DistantHorizons-2.4.5-b-1.21.11-fabric-neoforge.jar";
      flake = false;
    };
    Concurrent-Chunk-Management-Engine = {
      url = "https://cdn.modrinth.com/data/VSNURh3q/versions/olrVZpJd/c2me-fabric-mc1.21.11-0.3.6.0.0.jar";
      flake = false;
    };
    Universal-Shops = {
      url = "https://cdn.modrinth.com/data/cnIatHrN/versions/M6PTvMlM/universal_shops-1.13.0%2B1.21.11.jar";
      flake = false;
    };
    Polymer = {
      url = "https://cdn.modrinth.com/data/xGdtZczs/versions/wugBT1fU/polymer-bundled-0.15.2%2B1.21.11.jar";
      flake = false;
    };
    Essential-Commands = {
      url = "https://cdn.modrinth.com/data/6VdDUivB/versions/3s9XXmZa/essential_commands-0.38.6-mc1.21.11.jar";
      flake = false;
    };
    Elytra-Trims = {
      url = "https://cdn.modrinth.com/data/XpzGz7KD/versions/Nzd1iQCn/elytratrims-fabric-4.6.2%2B1.21.11.jar";
      flake = false;
    };
    Dragon-Drops-Elytra = {
      url = "https://cdn.modrinth.com/data/DPkbo3dg/versions/NwRksTCY/dragondropselytra-1.21.11-3.5.jar";
      flake = false;
    };
    Collective = {
      url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/T8rv7kwo/collective-1.21.11-8.13.jar";
      flake = false;
    };
    Armored-Elytra = {
      url = "https://cdn.modrinth.com/data/AuFCCYMx/versions/mKCSekSL/armored-elytra-1.12.0.jar";
      flake = false;
    };
    Bow-Infinity-Fix = {
      url = "https://cdn.modrinth.com/data/BFENfScW/versions/besCdt3U/BowInfinityFix-1.21.9-fabric-3.1.2.jar";
      flake = false;
    };
    Universal-Enchants = {
      url = "https://cdn.modrinth.com/data/DT56YDir/versions/MuPwsQLB/UniversalEnchants-v21.11.2-mc1.21.11-Fabric.jar";
      flake = false;
    };
    Puzzles-Lib = {
      url = "https://cdn.modrinth.com/data/QAGBst4M/versions/7L1WGsjw/PuzzlesLib-v21.11.6-mc1.21.11-Fabric.jar";
      flake = false;
    };
    Grind-Enchantments = {
      url = "https://cdn.modrinth.com/data/WC4UgDcZ/versions/XX0LqtxX/grind-enchantments-4.1.0%2B1.21.11-pre2.jar";
      flake = false;
    };
    Unlimited-Enchantments = {
      url = "https://cdn.modrinth.com/data/6YplFU9p/versions/b0x3rZY5/unlimited-enchantments-1.1.1%2B1.21.X.jar";
      flake = false;
    };
    Inventory-Sorting = {
      url = "https://cdn.modrinth.com/data/5ibSyLAz/versions/Dq4h9aTH/inventorysorter-fabric-2.1.4%2Bmc1.21.11.jar";
      flake = false;
    };
  };
  outputs = {self, ...} @ inputs:
    with inputs; let
      # System types to support.
      supportedSystems = [
        "x86_64-linux"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (
        system:
          import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
              nix-minecraft.overlay
            ];
          }
      );

      clan-facts = builtins.fromJSON (builtins.readFile ./clan-facts.json);
      clan = clan-core.lib.clan {
        # this needs to point at the repository root
        inherit self;

        # Make inputs and the flake itself accessible as module parameters.
        # Technically, adding the inputs is redundant as they can be also
        # accessed with flake-self.inputs.X, but adding them individually
        # allows to only pass what is needed to each module.
        specialArgs =
          {
            flake-self = self;
            inherit clan-facts;
          }
          // inputs;

        # Register custom clan service modules
        modules."@andrewthomaslee/machine-type" = ./clan-service-modules/machine-type;
        modules."@andrewthomaslee/kde" = ./clan-service-modules/kde;

        inventory = import ./inventory.nix {inherit self clan-facts;};
      };
    in {
      devShells = forAllSystems (
        system:
          with nixpkgsFor.${system}; {
            default = pkgs.mkShell {
              buildInputs = [pkgs.bash];
              packages = [
                clan-core.packages.${system}.clan-cli
              ];
            };
          }
      );

      # Custom packages added via the overlay are selectively exposed here, to
      # allow using them from other flakes that import this one.
      packages = forAllSystems (
        system: let
          pkgs = nixpkgsFor.${system};
        in
          {
            inherit (pkgs) hello-custom;
          }
          // nixpkgs.lib.optionalAttrs (system == "x86_64-linux") {
            inherit (pkgs) playit;
          }
      );

      # Expose overlay to flake outputs, to allow using it from other flakes.
      # Flake inputs are passed to the overlay so that the packages defined in
      # it can use the sources pinned in flake.lock
      overlays.default = final: prev: (import ./overlays inputs self clan-net-utils) final prev;

      # Use alejandra for 'nix fmt'
      formatter = forAllSystems (system: nixpkgsFor.${system}.alejandra);

      # Each subdirectory in ./templates/<template-name> is a
      # template, which can be used for new proects with:
      # `nix flake init`
      templates =
        builtins.listToAttrs (
          map (name: {
            inherit name;
            value = {
              path = ./templates + "/${name}";
              description = (import (./templates + "/${name}/flake.nix")).description;
            };
          }) (builtins.attrNames (builtins.readDir ./templates))
        )
        // {
          uv2nix = {
            path = uv2nix-template;
            description = "Hello world application using uv2nix";
          };
        };

      # Output all modules in ./modules/<module-name> to flake. Modules should be in
      # individual subdirectories and contain a default.nix file.
      # Each subdirectory in ./modules/<module-name> is a nixos module
      nixosModules = builtins.listToAttrs (
        map (name: {
          inherit name;
          value = import (./modules + "/${name}");
        }) (builtins.attrNames (builtins.readDir ./modules))
      );

      # Each subdirectory in ./machines/<machine-name> is a host config. Clan
      # auto-imports all machines from ./machines
      inherit (clan.config) clanInternals nixosConfigurations;
      clan = clan.config;

      # Each subdirectory in ./home-manager/profiles/<profile-name> is a
      # home-manager profile
      homeConfigurations = builtins.listToAttrs (
        map
        (name: {
          inherit name;
          value = {...}: {
            imports =
              [
                (./home-manager/profiles + "/${name}")
              ]
              ++ (builtins.attrValues self.homeManagerModules);
          };
        })
        (
          builtins.attrNames (
            nixpkgs.lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./home-manager/profiles)
          )
        )
      );

      # Each subdirectory in ./home-manager/modules/<module-name> is a
      # home-manager module
      homeManagerModules = builtins.listToAttrs (
        map (name: {
          inherit name;
          value = import (./home-manager/modules + "/${name}");
        }) (builtins.attrNames (builtins.readDir ./home-manager/modules))
      );
    };
}
