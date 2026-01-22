{flake-self, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;
    hetzner.cloud.enable = true;

    services = {
      hugo = {
        enable = true;
        blogAndrewleeFun.enable = true;
      };
      headscale = {
        enable = true;
        base_domain = "netsam.dev";
        server_url = "vpn.netsam.dev";
        adminUser = "andrewthomaslee@netsam.com";
        client_id = "768131783288-cdrtl1ahhltlgcpl42pqdohabf0q623v.apps.googleusercontent.com";
        allowed_domains = ["netsam.com"];
      };
    };
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.server;
}
