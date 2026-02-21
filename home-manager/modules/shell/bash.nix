{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = config.clan-net.programs.bash;
in {
  options.clan-net.programs.bash.enable = lib.mkEnableOption "bash";

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      shellAliases = {
        sudo = "sudo ";
        root = "su root";
        sr = "su -l";
        ssh-key = "eval \"$(ssh-agent -s)\" && ssh-add ~/.ssh/id_ed25519";
        vact = "source .venv/bin/activate";
        # nix commands
        nfc = "nix flake check --all-systems --show-trace";
        nfu = "nix flake update";
        nd = "nix develop";
        nr = "nix run";
        nfs = "nix flake show --all-systems";
        nixos-facter = "sudo nix run nixpkgs#nixos-facter -- -o facter.json";
        # local nixos rebuild commands
        nixos-rebuild-boot = "sudo nixos-rebuild boot --flake /home/netsa/nixos#${osConfig.networking.hostName}";
        nixos-rebuild-switch = "sudo nixos-rebuild switch --flake /home/netsa/nixos#${osConfig.networking.hostName}";
        nixos-rebuild-test = "sudo nixos-rebuild test --flake /home/netsa/nixos#${osConfig.networking.hostName}";
        # nixos-rebuild tests
        nixos-current-system = "readlink -f /nix/var/nix/profiles/system && readlink -f /run/current-system";
        # misc
        speedtest = "NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#ookla-speedtest";
        modrinth-prefetch = "nix run github:Infinidoge/nix-minecraft#nix-modrinth-prefetch -- $@";
        # backups
        fabric-backup = "rsync -av --progress --delete kamrui-p1:/srv/minecraft/fabric/world/ /mnt/storagebox/BACKUPS/minecraft/fabric/world/";
      };
      bashrcExtra = ''
        # nixos remote rebuild
        nixos-remote() {
          if [ "$#" -lt 2 ]; then
            echo "Usage: nixos-remote <switch|boot|test> <host>"
            return 1
          fi

          local method="$1"
          local host="$2"

          if [[ ! "$method" =~ ^(switch|boot|test)$ ]]; then
            echo "Error: method must be switch, boot, or test"
            return 1
          fi

          nixos-rebuild "$method" --flake /home/netsa/nixos#"$host" --target-host root@"$host" --build-host root@localhost
        }
      '';
    };
  };
}
