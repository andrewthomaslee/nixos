{flake-self, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    virtualisation.docker.enable = true;

    services.netbird.enable = true;
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.desktop;
}
