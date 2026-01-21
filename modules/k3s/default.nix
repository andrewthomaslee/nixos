{
  pkgs,
  config,
  lib,
  clan-facts,
  ...
}: let
  cfg = config.clan-net.services.k3s;
  net = clan-facts.machines.${config.networking.hostName}.networking;
in {
  imports = [
    ./manager.nix
    ./worker.nix
  ];

  options.clan-net.services.k3s = {
    enable = lib.mkEnableOption "k3s";
    manager = lib.mkEnableOption "Control plane node";
    worker = lib.mkEnableOption "Worker node";
    init = lib.mkEnableOption "Initialize k3s";
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.k3s = {
      share = true;
      prompts = {
        "token" = {
          persist = true;
          type = "line";
          description = ''
            K3s Token
          '';
          display.group = "k3s";
        };
      };
      files = {
        "token" = {};
      };
    };

    # k3s
    services.k3s = {
      enable = true;
      package = pkgs.k3s_1_35;
      gracefulNodeShutdown.enable = true;
      clusterInit = cfg.init;
      tokenFile =
        if cfg.init
        then null
        else config.clan.core.vars.generators.k3s.files.token.path;
      serverAddr =
        if cfg.init
        then ""
        else "https://${clan-facts.machines.kamuri-P1-0.networking.IPv4.address}:6443";
      nodeIP = net.IPv4.address;
    };
  };
}
