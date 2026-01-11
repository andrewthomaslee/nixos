{
  config,
  lib,
  ...
}: let
  cfg = config.clan-net.programs.starship;
in {
  options.clan-net.programs.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        aws.disabled = true;
        gcloud.disabled = true;
        kubernetes = {
          disabled = false;
          detect_env_vars = ["KUBECONFIG"];
        };
        git_branch.style = "242";
        directory.style = "bold blue";
        directory.truncate_to_repo = true;
        directory.truncation_length = 10;
        python.disabled = false;
        ruby.disabled = true;
        hostname.ssh_only = false;
        hostname.style = "bold green";
        nix_shell = {
          symbol = "❄  ";
        };
        git_status = {
          ahead = "↑";
          behind = "↓";
          diverged = "↕";
          modified = "!";
          staged = "±";
          renamed = "→";
        };
      };
    };
  };
}
