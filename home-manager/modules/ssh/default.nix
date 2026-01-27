{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.defaults.ssh;
in {
  options.clan-net.defaults.ssh.enable = lib.mkEnableOption "SSH configuration";

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "nixos" = {
          hostname = "nixos";
          user = "root";
          port = 22;
          addKeysToAgent = "yes";
          extraOptions = {
            "PreferredAuthentications" = "publickey";
          };
        };
        "ghost" = {
          hostname = "ghost";
          user = "root";
          port = 22;
          addKeysToAgent = "yes";
          extraOptions = {
            "PreferredAuthentications" = "publickey";
          };
        };
        "kamrui-p1" = {
          hostname = "kamrui-p1";
          user = "root";
          port = 22;
          addKeysToAgent = "yes";
          extraOptions = {
            "PreferredAuthentications" = "publickey";
          };
        };
        "helsinki-vps" = {
          hostname = "helsinki-vps";
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
