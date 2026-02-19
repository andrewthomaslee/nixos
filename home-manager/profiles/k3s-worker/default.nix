{...}: {
  imports = [../common.nix];

  config = {
    clan-net = {
      defaults = {
        shell.enable = true;
        xdg.enable = true;
      };

      programs = {
        tmux.enable = true;
        bash.enable = true;
        starship.enable = true;
      };
    };
  };
}
