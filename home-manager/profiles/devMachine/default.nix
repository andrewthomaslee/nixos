{pkgs, ...}: {
  imports = [../common.nix];

  config = {
    home.keyboard = {
      layout = "us";
    };

    clan-net = {
      defaults = {
        xdg.enable = true;
        ssh.enable = true;
        shell.enable = true;
        git.enable = true;
      };

      programs = {
        k9s.enable = true;
        zed.enable = true;
        tmux.enable = true;
        vscode.enable = true;
        taskwarrior.enable = true;
        go.enable = true;
        python.enable = true;
        ghostty.enable = true;
        nix.enable = true;
        bash.enable = true;
        starship.enable = true;
        docker.enable = true;
      };

      services = {
        ksshaskpass.enable = true;
      };
    };

    # Install these packages for my user
    home.packages = with pkgs; [
      usbutils
      wireguard-tools
      asciinema
      obsidian
      prismlauncher # minecraft launcher
      tor-browser
      kalker # CLI Calculator
      zen-browser
      moscripts
      lazyssh
      lazyjournal
      jq
      yq
      rsync
      httpie
      mediawriter
    ];
  };
}
