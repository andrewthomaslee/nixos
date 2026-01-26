{flake-self, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    virtualisation.docker.enable = true;

    # networking = {
    #   netbird.industrial-host = {
    #     enable = true;
    #     port = 51821;
    #   };
    # };
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.desktop;
}
