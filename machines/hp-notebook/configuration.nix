{flake-self, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;
  };

  # User Profiles
  home-manager.users.madi = flake-self.homeConfigurations.madi;
  home-manager.users.root = flake-self.homeConfigurations.madi;
}
