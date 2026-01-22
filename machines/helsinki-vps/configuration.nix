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
        allowed_domains = ["netsam.com"];
      };
    };
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.server;
}
