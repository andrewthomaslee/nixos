{flake-self, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;
    hetzner.cloud.enable = true;

    services = {
      acme.cloudflare.enable = true;
      nginx.enable = true;
      hugo = {
        blogAndrewleeFun.enable = true;
      };
    };
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.server;
}
