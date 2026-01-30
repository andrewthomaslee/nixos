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
      headscale = let
        adminUser = "andrewlee";
        adminEmail = clan-facts.email;
        domain = "andrewlee.cloud";
        base_domain = "ts.${domain}";
        minecraft_node_ip = "100.64.0.3";
        guests = [
          "maddieraye21@gmail.com"
        ];
      in {
        inherit adminUser adminEmail base_domain;
        server_url = "headscale.${domain}";
        enable = true;
        derp = {
          enabled = true;
          ipv4 = clan-facts.machines.${config.networking.hostName}.networking.IPv4.address;
          ipv6 = clan-facts.machines.${config.networking.hostName}.networking.IPv6.address;
        };
        allowed_users =
          [
            adminEmail
          ]
          ++ guests;

        aclConfig = {
          # 1. Groups Definition
          groups = {
            "group:admins" = [adminEmail];
            "group:clan-net" = [adminEmail];
            "group:guests" = guests;
          };

          # 2. Tag Owners
          tagOwners = {
            "tag:clan-net" = ["group:admins"];
          };

          # 3. DNS Aliases (Hosts)
          # These map names to IPs for everyone in the network.
          hosts = {
            # Map 'minecraft.ts.andrewlee.cloud' to the Headscale IP of kamrui-p1
            "minecraft.${base_domain}" = "${minecraft_node_ip}";
          };

          # 4. ACL Rules
          acls = [
            # --- ADMIN ACCESS ---
            {
              action = "accept";
              src = ["group:admins"];
              dst = ["*:*"];
            }

            # --- CLAN NET MESH ---
            {
              action = "accept";
              src = ["group:clan-net" "tag:clan-net"];
              dst = ["group:clan-net:*" "tag:clan-net:*" "group:guests:*"];
            }

            # --- MINECRAFT GUEST ACCESS ---
            {
              action = "accept";
              src = ["group:guests"];
              dst = [
                # Allow access specifically to the Minecraft alias on port 25565
                "minecraft.${base_domain}:25565"
              ];
            }
          ];

          # 5. Auto Approvers
          autoApprovers = {
            # Approve subnet routes so kube-vip is reachable
            routes = {
              "192.168.1.0/24" = ["group:admins" "tag:clan-net"];
            };
            exitNode = ["group:admins" "tag:clan-net" "group:guests"];
          };
        };
      };
    };
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.server;
  home-manager.users.root = flake-self.homeConfigurations.server;
}
