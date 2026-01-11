{
  config,
  lib,
  pkgs,
  flake-self,
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
            catppuccin.catppuccin-vsc-icons
            ms-toolsai.jupyter
            rooveterinaryinc.roo-cline
            irongeek.vscode-env
            hashicorp.terraform
            budparr.language-hugo-vscode
            gruntfuggly.todo-tree
          ];
          userSettings = {
            "security.workspace.trust.untrustedFiles" = "open";
            "terminal.integrated.defaultProfile.linux" = "bash";
            "workbench.sideBar.location" = "right";
            "workbench.colorTheme" = "Red";
            "workbench.iconTheme" = "catppuccin-macchiato";
            "redhat.telemetry.enabled" = false;
            "workbench.startupEditor" = "none";
            "editor.minimap.renderCharacters" = false;
            "editor.minimap.size" = "fill";
            "editor.minimap.enabled" = false;
            "explorer.confirmDragAndDrop" = false;
            "git.autofetch" = true;
            "explorer.confirmDelete" = false;
            "explorer.confirmPasteNative" = false;
            "python.createEnvironment.trigger" = "off";
            "python.defaultInterpreterPath" = "";
            "tailwindCSS.classAttributes" = [
              "class"
              "className"
              "ngClass"
              "class:list"
              "_klass"
              "klass"
              "_style"
              "style"
            ];
            "tailwindCSS.includeLanguages" = {
              python = "html";
            };
            "git.enableSmartCommit" = true;
            "git.confirmSync" = false;
            "python.experiments.enabled" = false;
            "[jsonc]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };
            "python.languageServer" = "Default";
            "ruff.configurationPreference" = "filesystemFirst";
            "supermaven.enable" = {
              "*" = true;
            };
            "sqltools.useNodeRuntime" = true;
            "tailwind-fold.autoFold" = false;
            "[python]" = {
              "editor.formatOnSave" = true;
              "editor.defaultFormatter" = "charliermarsh.ruff";
            };
            "yaml.schemaStore.url" =
              "https://raw.githubusercontent.com/weaveworks/eksctl/main/pkg/apis/eksctl.io/v1alpha5/assets/schema.json";
            "[dockercompose]" = {
              "editor.insertSpaces" = true;
              "editor.tabSize" = 2;
              "editor.autoIndent" = "advanced";
              "editor.defaultFormatter" = "redhat.vscode-yaml";
            };
            "[github-actions-workflow]" = {
              "editor.defaultFormatter" = "redhat.vscode-yaml";
            };
            "workbench.secondarySideBar.defaultVisibility" = "hidden";
            "vs-kubernetes" = {
              "vs-kubernetes.crd-code-completion" = "enabled";
            };
            "terminal.integrated.enableMultiLinePasteWarning" = "never";
            "[nix]" = {
              "editor.formatOnPaste" = false;
              "editor.formatOnSave" = true;
              "editor.formatOnType" = false;
            };
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nil";
            "nix.formatterPath" = [
              "treefmt"
              "--stdin"
              "{file}"
            ];
            "nix.serverSettings" = {
              nil = {
                formatting = {
                  command = [
                    "treefmt"
                    "--stdin"
                    "{file}"
                  ];
                };
                nix = {
                  maxMemoryMB = 4096;
                  flake = {
                    autoArchive = true;
                    autoEvalInputs = true;
                  };
                };
              };
            };
            "roo-cline.allowedCommands" = [
              "git log"
              "git diff"
              "git show"
            ];
          };
        };
      };
    };
    home.packages =
      with pkgs;
      [
        pyrefly
        ruff
        nil
        helm-ls
        terraform-ls
        gemini-cli
        kubectl
      ]
      ++ [
        flake-self.packages.${pkgs.stdenv.hostPlatform.system}.treefmt
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
