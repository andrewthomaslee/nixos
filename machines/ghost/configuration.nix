{flake-self, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    virtualisation.docker.enable = true;
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.desktop;
  home-manager.users.root = flake-self.homeConfigurations.desktop;
}
