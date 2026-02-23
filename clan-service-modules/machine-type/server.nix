{flake-self, ...}: {
  clan-net = {
    defaults = {
      environment.enable = true;
      locale.enable = true;
      nix.enable = true;
      storagebox = {
        enable = true;
        mountOnAccess = false;
        boxUser = "u488514-sub1";
      };
    };
    services = {
      openssh.enable = true;
      motd.enable = true;
    };

    networking.tailscale.enable = true;
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.server;
  home-manager.users.root = flake-self.homeConfigurations.server;
}
