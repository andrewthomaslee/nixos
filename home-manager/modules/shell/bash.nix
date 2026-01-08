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
        nfc = "nix flake check --all-systems --show-trace";
        nfu = "nix flake update";
        nd = "nix develop";
        nr = "nix run";
        nfs = "nix flake show";
        nixos-facter = "sudo nix run nixpkgs#nixos-facter -- -o facter.json";
        nixos-rebuild-boot = "sudo nixos-rebuild boot --flake /home/netsa/nixos#${osConfig.networking.hostName}";
        nixos-rebuild-switch = "sudo nixos-rebuild switch --flake /home/netsa/nixos#${osConfig.networking.hostName}";
      };
    };
  };
}
