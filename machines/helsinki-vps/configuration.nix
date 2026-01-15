{flake-self, ...}: {
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

  # Enable the PostgreSQL backup module
  clan.core.postgresql.enable = true;
  clan.core.postgresql.users.test = {
    name = "test";
  };
  # Configure each database
  clan.core.postgresql.databases.test = {
    # Database creation options (runs on first setup)
    name = "test";
    create = {
      enable = true;
      options = {
        ENCODING = "UTF8";
        LC_COLLATE = "C";
        LC_CTYPE = "C";
        OWNER = "test";
        TEMPLATE = "template0";
      };
    };
  };

  # User Profiles
  home-manager.users.netsa = flake-self.homeConfigurations.server;
}
