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
      };

      programs = {
        firefox.enable = true;
        bash.enable = true;
        starship.enable = true;
      };
    };

    # Install these packages for my user
    home.packages = with pkgs; [
      mpv
      imagemagick
      spotify
      obsidian
    ];
  };
}
