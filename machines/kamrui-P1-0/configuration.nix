{flake-self, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    services = {
      qdrant.enable = true;
      netbird.enable = true;
      k3s = {
        enable = true;
        manager = true;
        init = true;
      };
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
