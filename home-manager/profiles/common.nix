{
  lib,
  pkgs,
  flake-self,
  ...
}:
with lib;
{
  config = {
    # Home-manager nixpkgs config
    nixpkgs = {
      # Allow "unfree" licenced packages
      config = {
        allowUnfree = true;
      };

      overlays = [
        flake-self.overlays.default
      ];
    };

    # Extra arguments to pass to modules
    _module.args = {
      flake-inputs = flake-self.inputs;
      clan-net-utils = import ../../utils { inherit pkgs; };
      clan-facts = builtins.fromJSON (builtins.readFile ./../../clan-facts.json);
    };

    # Include man-pages
    manual.manpages.enable = true;

    home = {
      # Install these packages for my user
      packages = with pkgs; [
        jq
        yq
        rsync
        tree
        httpie
        vulnix
        fastfetch
        busybox
      ];

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "25.05";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
