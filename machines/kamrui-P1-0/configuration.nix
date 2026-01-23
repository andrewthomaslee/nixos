{flake-self, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    services = {
      netbird.enable = true;
      minecraft.enable = true;
    };
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.server;

  # Enable GPU acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
