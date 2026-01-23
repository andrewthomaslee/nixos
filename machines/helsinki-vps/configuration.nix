{
  config,
  flake-self,
  clan-facts,
  ...
}: {
  clan-net = {
    filesystems.ext4.enable = true;
    hetzner.cloud.enable = true;

    services = {
      hugo = {
        enable = true;
        blogAndrewleeFun.enable = true;
      };
    };
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.server;
}
