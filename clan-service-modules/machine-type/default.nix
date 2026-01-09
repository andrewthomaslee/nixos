{
  _class = "clan.service";
  manifest.name = "machine-type";
  manifest.readme = "Machine classification/profiles";

  roles.server.perInstance.nixosModule = ./server.nix;
  roles.server.description = "Server machine settings, no GUI";
  roles.desktop.perInstance.nixosModule = ./desktop.nix;
  roles.desktop.description = "Desktop machine settings, including kde";

  # Common configuration for all macine types
  perMachine.nixosModule =
    { lib, ... }:
    {
      security.acme.acceptTerms = true;
      security.acme.defaults.email = lib.mkDefault "andrewthomaslee.business@gmail.com";
      clan.core.settings.state-version.enable = true;
      hardware.enableRedistributableFirmware = true;
      environment = {
        enableAllTerminfo = true;
        localBinInPath = true;
      };
    };
}
