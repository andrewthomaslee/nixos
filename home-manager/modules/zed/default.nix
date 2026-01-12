{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.clan-net.programs.zed;
  packages = with pkgs;
    [
      nixd
      alejandra
      pyrefly
      helm-ls
      ruff
      dockerfile-language-server
      bash-language-server
      nil
      terraform-ls
      gemini-cli
      kubectl
      jsonnet-language-server
      markdown-oxide
      docker-compose-language-service
      nginx-language-server
      sqls
    ]
    ++ (with tree-sitter-grammars; [
      tree-sitter-dockerfile
      tree-sitter-nix
      tree-sitter-python
      tree-sitter-markdown
      tree-sitter-json
      tree-sitter-html
      tree-sitter-css
      tree-sitter-go
      tree-sitter-javascript
      tree-sitter-rust
      tree-sitter-bash
      tree-sitter-yaml
      tree-sitter-sql
      tree-sitter-toml
      tree-sitter-nginx
    ]);
in {
  options.clan-net.programs.zed = {
    enable = mkEnableOption "Zed editor configuration";
  };

  config = mkIf cfg.enable {
    home.packages = packages;
    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
      extensions = [
        "nix"
        "html-snippets"
        "css-snippets"
        "pyrefly"
        "csv"
        "dockerfile"
        "terraform"
        "zig"
        "bash"
        "helm"
        "python-snippets"
        "jsonnet"
        "base16"
        "markdown-oxide"
        "docker-compose"
        "sql"
        "toml"
        "nginx"
      ];
      extraPackages = packages;
      userSettings = {
        telemetry = {
          metrics = false;
          diagnostics = false;
        };
        minimap = {
          show = "never";
        };
        base_keymap = "VSCode";
        vim_mode = false;
        ui_font_size = 18;
        buffer_font_size = 15;
        buffer_font_family = "FreeMono";
        ui_font_family = "FreeMono";
        load_direnv = "shell_hook";
        theme = {
          mode = "system";
          light = "Base16 Decaf";
          dark = "Base16 Darktooth";
        };
        languages = {
          Nix = {
            tab_size = 2;
            formatter.external = {
              command = "alejandra";
              args = ["--quiet" "--"];
            };
            format_on_save = "on";
            language_servers = ["nixd" "!nil"];
          };
          Python = {
            language_servers = ["pyrefly" "!pyright" "!pylsp"];
          };
        };
      };
    };
  };
}
