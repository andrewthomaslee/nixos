{
  _class = "clan.service";
  manifest.name = "machine-type";
  manifest.readme = "Machine classification/profiles";

  roles.server.perInstance.nixosModule = ./server.nix;
  roles.server.description = "Server machine settings, no GUI";
  roles.desktop.perInstance.nixosModule = ./desktop.nix;
  roles.desktop.description = "Desktop machine settings, including kde";
  roles.devMachine.perInstance.nixosModule = ./devMachine.nix;
  roles.devMachine.description = "Development machine settings ie ( Andrew's work stations )";

  # Common configuration for all macine types
  perMachine.nixosModule = {
    pkgs,
    lib,
    config,
    flake-self,
    home-manager,
    nix-minecraft,
    determinate,
    ...
  }: {
    # Home manager
    imports = [
      home-manager.nixosModules.home-manager
      nix-minecraft.nixosModules.minecraft-servers
      determinate.nixosModules.default
    ];
    home-manager = {
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      extraSpecialArgs = {
        inherit flake-self;
        system-config = config;
      };
    };

    # pkgs overlay from flake
    nixpkgs.overlays = [
      flake-self.overlays.default
      nix-minecraft.overlay
    ];

    # acme
    security.acme = {
      acceptTerms = true;
      defaults.email = lib.mkDefault "andrewthomaslee.business@gmail.com";
    };

    # Limit log size for journal
    services.journald.extraConfig = lib.mkDefault "SystemMaxUse=10G";

    # Clan
    clan.core.settings.state-version.enable = true;

    # Hardware
    hardware.enableRedistributableFirmware = true;

    # Networking
    networking.networkmanager.enable = true;

    # System Environment
    environment = {
      enableAllTerminfo = true;
      localBinInPath = true;
      systemPackages = with pkgs; [
        git
        neovim
        vim
        busybox
        tailscale
        httpie
        rsync
        fastfetch
        fh
      ];
    };
  };
}
