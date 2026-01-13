{flake-self, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;
  };
  home-manager.users.netsa = flake-self.homeConfigurations.server;
}
