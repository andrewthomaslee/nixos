inputs: flake-self: clan-net-utils: let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;

  # Pass flake itself, so we can build packages from it
  inherit flake-self;
in
  self: super: {
    zen-browser = inputs.zen-browser.packages.${super.stdenv.hostPlatform.system}.default;
    moscripts = inputs.moscripts.packages.${super.stdenv.hostPlatform.system}.default;
    clan-cli = inputs.clan-core.packages.${super.stdenv.hostPlatform.system}.clan-cli;

    # Netbird
    netbird = inputs.nixpkgs-unstable.legacyPackages.${super.stdenv.hostPlatform.system}.netbird;
    netbird-ui = inputs.nixpkgs-unstable.legacyPackages.${super.stdenv.hostPlatform.system}.netbird-ui;
    netbird-relay = inputs.nixpkgs-unstable.legacyPackages.${super.stdenv.hostPlatform.system}.netbird-relay;
    netbird-upload = inputs.nixpkgs-unstable.legacyPackages.${super.stdenv.hostPlatform.system}.netbird-upload;
    netbird-signal = inputs.nixpkgs-unstable.legacyPackages.${super.stdenv.hostPlatform.system}.netbird-signal;
    netbird-dashboard = inputs.nixpkgs-unstable.legacyPackages.${super.stdenv.hostPlatform.system}.netbird-dashboard;
    netbird-management = inputs.nixpkgs-unstable.legacyPackages.${super.stdenv.hostPlatform.system}.netbird-management;

    # k3s
    k3s_1_35 = inputs.nixpkgs-unstable.legacyPackages.${super.stdenv.hostPlatform.system}.k3s_1_35;

    # tailscale
    tailscale = inputs.nixpkgs-unstable.legacyPackages.${super.stdenv.hostPlatform.system}.tailscale;

    # Example package, used only for tests
    hello-custom = super.callPackage ../packages/hello-custom {};

    # https://playit.gg
    playit = super.callPackage ../packages/playit {inherit inputs;};

    # fix for kubefetch
    kubefetch = inputs.kubefetch.packages.${super.stdenv.hostPlatform.system}.default;
  }
