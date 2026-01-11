{
  description = "andrewthomaslee's nixos (inspired by github.com/pinpox/nixos )";

  inputs = {
    # Clan.lol
    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";

    # Rolling Release of Nixpkgs from Clan.lol
    nixpkgs.follows = "clan-core/nixpkgs";


    # --- Flakes --- #
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tailscale = {
      url = "https://github.com/tailscale/tailscale/archive/refs/tags/v1.92.5.tar.gz";
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
  };
  outputs =
    { self, ... }@inputs:
    with inputs;
    let
      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
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
        specialArgs = {
          flake-self = self;
          inherit clan-facts;
        }
        // inputs;

        # Register custom clan service modules
        modules."@andrewthomaslee/machine-type" = ./clan-service-modules/machine-type;
        modules."@andrewthomaslee/desktop" = ./clan-service-modules/desktop;

        inventory = import ./inventory.nix { inherit self clan-facts; };
      };
    in
    {
      devShells = forAllSystems (
        system: with nixpkgsFor.${system}; {
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
        system: with nixpkgsFor.${system}; {
          inherit hello-custom;
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
      templates = builtins.listToAttrs (
        map (name: {
          inherit name;
          value = {
            path = ./templates + "/${name}";
            description = (import (./templates + "/${name}/flake.nix")).description;
          };
        }) (builtins.attrNames (builtins.readDir ./templates))
      );

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
            value =
              { ... }:
              {
                imports = [
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
