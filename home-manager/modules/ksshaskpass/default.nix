{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.clan-net.services.ksshaskpass;
in {
  options.clan-net.services.ksshaskpass.enable = lib.mkEnableOption "KDE ksshaskpass";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.kdePackages.ksshaskpass];
    xdg.configFile."environment.d/ssh_askpass.conf".text = ''
      SSH_ASKPASS="/run/current-system/sw/bin/ksshaskpass"
    '';
    xdg.configFile."autostart/ssh-add.desktop".text = ''
      [Desktop Entry]
      Exec=ssh-add -q
      Name=ssh-add
      Type=Application
    '';
    xdg.configFile."plasma-workspace/env/ssh-agent-startup.sh" = {
      text = ''
        #!/bin/sh
        [ -n "$SSH_AGENT_PID" ] || eval "$(ssh-agent -s)"
      '';
      executable = true;
    };
    xdg.configFile."plasma-workspace/shutdown/ssh-agent-shutdown.sh" = {
      text = ''
        #!/bin/sh
        [ -z "$SSH_AGENT_PID" ] || eval "$(ssh-agent -k)"
      '';
      executable = true;
    };
  };
}
