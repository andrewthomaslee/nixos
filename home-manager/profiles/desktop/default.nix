{pkgs, ...}: {
  imports = [../common.nix];

  config = {
    home.keyboard = {
      layout = "us";
    };

    clan-net = {
      defaults = {
        xdg.enable = true;
        ssh.enable = false;
        shell.enable = true;
        git.enable = true;
      };

      programs = {
        k9s.enable = false;
        zed.enable = false;
        firefox.enable = true;
        tmux.enable = true;
        vscode.enable = true;
        taskwarrior.enable = true;
        go.enable = true;
      };

      services = {
        ksshaskpass.enable = true;
      };
    };

    # Install these packages for my user
    home.packages = with pkgs; [
      mpv
      imagemagick
      spotify
      asciinema
      obsidian
      prismlauncher # minecraft launcher
      tor
      kalker # CLI Calculator
    ];

    services = {
      # Applets, shown in tray

      # Networking
      network-manager-applet.enable = true;

      # Bluetooth
      blueman-applet.enable = true;

      # Pulseaudio
      pasystray.enable = true;

      # Battery Warning
      cbatticon.enable = true;
    };
  };
}
