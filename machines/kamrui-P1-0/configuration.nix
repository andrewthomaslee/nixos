{flake-self, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    services = {
      netbird.enable = true;
      minecraft = {
        enable = true;
        jvmOpts = "-Xms4G -Xmx8G -XX:+UseG1GC -XX:ParallelGCThreads=8 -XX:+DisableExplicitGC";
        whitelist = {
          netsammateo = "06c0f83a-7ffe-466c-be19-b3c247b1438c";
          scorch3000 = "1380ccf2-aef4-4cb3-8d18-cf3642dac80c";
          Dingleborf = "0c86d5d5-44f4-4752-ae87-927beaeca0d5";
          GrimpTheImp = "df7a653a-e6d3-4287-84db-e06fb989bb58";
          sapphyy = "7ef1c05d-86b9-49fc-a3cf-ed1918818e2f";
        };
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
