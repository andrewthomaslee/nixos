{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.clan-net.services.ollama;
in {
  options.clan-net.services.ollama = {
    enable = lib.mkEnableOption "ollama";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ollama-cpu;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      ollama = {
        enable = true;
        port = 11434;
        openFirewall = true;
        package = cfg.package;
        host = "localhost";
      };
      nextjs-ollama-llm-ui = {
        enable = true;
        hostname = "localhost";
        port = 8434;
        ollamaUrl = "http://localhost:11434";
      };
      # tailscale.serve = {
      #   enable = true;
      #   services.ollama = {
      #     advertised = true;
      #     endpoints = {
      #       "tcp:11434" = "tcp://localhost:11434";
      #     };
      #   };
      # };
    };
  };
}
