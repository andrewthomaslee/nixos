{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.clan-net.defaults.git;
in {
  options.clan-net.defaults.git.enable = mkEnableOption "git defaults";

  config = mkIf cfg.enable {
    programs = {
      lazygit.enable = true;

      git = {
        enable = true;
        lfs.enable = true;

        ignores = [
          "tags"
          "*.swp"
          "result"
          ".claude"
        ];

        settings = {
          extraConfig = {
            init.defaultBranch = "main";

            pull = {
              rebase = true;
              autostash = true;
              twohead = "ort";
            };

            push = {
              default = "simple";
              autoSetupRemote = true;
            };

            branch = {
              autoSetupRebase = "always";
              autoSetupMerge = "always";
            };

            rebase = {
              stat = true;
              autoStash = true;
              autoSquash = true;
              updateRefs = true;
            };

            help.autocorrect = 10;
          };

          signing = {
            format = "ssh";
            key = "~/.ssh/id_ed25519.pub";
            signByDefault = true;
          };

          aliases = {
            s = "status";
            d = "diff";
            a = "add";
            c = "commit";
            p = "push";
            o = "checkout";
            co = "checkout";
            uncommit = "reset --soft HEAD^";
            comma = "commit --amend";
            reset-pr = "reset --hard FETCH_HEAD";
            force-push = "push --force-with-lease";
          };

          user.email = "andrewthomaslee.business@gmail.com";
          user.name = "andrewthomaslee";
        };
      };
    };
  };
}
