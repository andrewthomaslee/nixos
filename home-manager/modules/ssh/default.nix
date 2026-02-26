{
  config,
  lib,
  clan-facts,
  osConfig,
  ...
}: let
  cfg = config.clan-net.defaults.ssh;
in {
  options.clan-net.defaults.ssh.enable = lib.mkEnableOption "SSH configuration";

  config = lib.mkIf cfg.enable {
    programs.ssh = let
      extraOptions = {
        "PreferredAuthentications" = "publickey";
        "StrictHostKeyChecking" = "no";
        # "UserKnownHostsFile" = "/dev/null";
      };
      addKeysToAgent = "yes";

      tailscale = names:
        lib.genAttrs names (name: {
          hostname = name;
          user = "root";
          port = 22;
          inherit extraOptions addKeysToAgent;
        });

      local = names:
        builtins.listToAttrs (map
          (name: {
            name = "${name}.local";
            value = {
              hostname = clan-facts.networking.public.IPv4.${name};
              user = "root";
              port = 22;
              inherit extraOptions addKeysToAgent;
            };
          })
          names);
    in {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks =
        {
          helsinki-box = {
            hostname = "u488514.your-storagebox.de";
            user = "u488514";
            port = 23;
            inherit extraOptions addKeysToAgent;
          };
          helsinki-box-sub1 = lib.optionalAttrs (osConfig.clan-net.defaults.storagebox.boxUser == "u488514-sub1") {
            hostname = "u488514-sub1.your-storagebox.de";
            user = "u488514-sub1";
            port = 23;
            inherit extraOptions addKeysToAgent;
            identityFile = osConfig.clan.core.vars.generators."storagebox-ssh-u488514-sub1".files."ssh-private-key".path;
          };
          industrial-host-box = {
            hostname = "u540833.your-storagebox.de";
            user = "u540833";
            port = 23;
            inherit extraOptions addKeysToAgent;
          };
        }
        // (tailscale [
          "nixos"
          "ghost"
          "kamrui-p1"
          "inuc"
          "mng-0-dev"
          "mng-2-dev"
          "mng-1-dev"
          "wrk-0-dev"
          "wrk-1-dev"
          "wrk-2-dev"
          "proxy-dev"
          "docker-dev"
          "mng-0-prod"
          "mng-1-prod"
          "mng-2-prod"
          "wrk-0-prod"
          "wrk-1-prod"
          "wrk-2-prod"
          "proxy-prod"
          "docker-prod"
        ])
        // (local [
          "nixos"
          "ghost"
          "kamrui-p1"
          "inuc"
        ]);
    };
  };
}
