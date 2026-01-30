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
      headscale = {
        enable = true;
        derp = {
          enabled = true;
          ipv4 = clan-facts.machines.${config.networking.hostName}.networking.IPv4.address;
          ipv6 = clan-facts.machines.${config.networking.hostName}.networking.IPv6.address;
        };
        base_domain = "vpn.andrewlee.cloud";
        adminUser = "netsa";
        adminEmail = clan-facts.email;
        allowed_users = [
          clan-facts.email
          "matt@netsam.com"
        ];
      };
    };
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.server;
  home-manager.users.root = flake-self.homeConfigurations.server;
}
