{pkgs, ...}: {
  imports = [../common.nix];

  config = {
    home.keyboard = {
      layout = "us";
    };

    clan-net = {
      defaults.xdg.enable = true;
      programs.firefox.enable = true;
    };

    # Install these packages for my user
    home.packages = with pkgs; [
      spotify
      mpv
      imagemagick
      spotify
    ];
  };
}
