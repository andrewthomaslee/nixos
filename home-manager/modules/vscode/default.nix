{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.clan-net.programs.vscode;
in
{
  options.clan-net.programs.vscode.enable = lib.mkEnableOption "vscode";

  config = lib.mkIf cfg.enable {
    # VSCode
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = true;
      profiles = {
        default = {
          extensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            supermaven.supermaven
            bradlc.vscode-tailwindcss
            redhat.vscode-yaml
            redhat.vscode-xml
            charliermarsh.ruff
            ms-python.python
            tamasfe.even-better-toml
            ziglang.vscode-zig
            esbenp.prettier-vscode
            ecmel.vscode-html-css
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
            ms-toolsai.jupyter
            kamadorueda.alejandra
            rooveterinaryinc.roo-cline
            irongeek.vscode-env
            hashicorp.terraform
            budparr.language-hugo-vscode
            gruntfuggly.todo-tree
          ];
        };
      };
    };

    home.file = {
      ".config/VSCodium/User/settings.json".source = lib.mkDefault ./settings.json;
    };
    home.packages = with pkgs; [
      pyrefly
      ruff
      alejandra
      nil
      helm-ls
      terraform-ls
    ];

    programs.bash = {
      shellAliases = {
        c = "codium .";
        cnix = "codium /home/netsa/nixos";
        cvscode = "codium /home/netsa/nixos/home-manager/modules/vscode/settings.json";
        cknownhosts = "codium ~/.ssh/known_hosts";
      };
    };
  };
}
