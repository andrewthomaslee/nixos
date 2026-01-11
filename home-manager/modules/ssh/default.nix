{
  config,
  lib,
  clan-facts,
  ...
}: let
  cfg = config.clan-net.defaults.ssh;
  tailnet = clan-facts.tailscale.tailnet;
in {
  options.clan-net.defaults.ssh.enable = lib.mkEnableOption "SSH configuration";

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "nixos" = {
          hostname = "nixos.${tailnet}";
          user = "netsa";
          port = 22;
          addKeysToAgent = "yes";
          extraOptions = {
            "PreferredAuthentications" = "publickey";
          };
        };
        "ghost" = {
          hostname = "ghost.${tailnet}";
          user = "netsa";
          port = 22;
          addKeysToAgent = "yes";
          extraOptions = {
            "PreferredAuthentications" = "publickey";
          };
        };
        "kamrui-P1-0" = {
          hostname = "kamrui-P1-0.${tailnet}";
          user = "root";
          port = 22;
          addKeysToAgent = "yes";
          extraOptions = {
            "PreferredAuthentications" = "publickey";
          };
        };
        "helsinki-vps" = {
          hostname = "helsinki-vps.${tailnet}";
          user = "root";
          port = 22;
          addKeysToAgent = "yes";
          extraOptions = {
            "PreferredAuthentications" = "publickey";
          };
        };
        "helsinki-box" = {
          hostname = "u488514.your-storagebox.de";
          user = "u488514";
          port = 23;
          addKeysToAgent = "yes";
          extraOptions = {
            "PreferredAuthentications" = "publickey";
          };
        };
      };
    };
  };
}
