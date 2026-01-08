{...}: {
  imports = [../common.nix];

  config = {
    clan-net = {
      defaults = {
        shell.enable = true;
        ssh.enable = true;
        xdg.enable = true;
        git.enable = true;
      };

      programs = {
        tmux.enable = true;
      };
    };
  };
}
