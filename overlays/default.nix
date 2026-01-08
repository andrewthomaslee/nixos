inputs: flake-self: clan-net-utils: let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;

  # Pass flake itself, so we can build packages from it
  inherit flake-self;
in
  self: super: {
    tailscale = inputs.tailscale.packages.${super.stdenv.hostPlatform.system}.tailscale;
    zen-browser = inputs.zen-browser.packages.${super.stdenv.hostPlatform.system}.default;
    moscripts = inputs.moscripts.packages.${super.stdenv.hostPlatform.system}.default;
    clan-cli = inputs.clan-core.packages.${super.stdenv.hostPlatform.system}.clan-cli;

    # Example package, used only for tests
    hello-custom = super.callPackage ../packages/hello-custom {};
  }
