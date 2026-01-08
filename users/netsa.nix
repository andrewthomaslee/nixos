{
  pkgs,
  clan-facts,
  ...
}: {
  users = {
    extraGroups.vboxusers.members = ["netsa"];
    defaultUserShell = pkgs.bash;
    users.netsa = {
      packages = with pkgs; [
        clan-cli
      ];

      isNormalUser = true;
      home = "/home/netsa";
      description = "andrewthomaslee";
      extraGroups = [
        "docker"
        "wheel"
        "networkmanager"
        "audio"
        "libvirtd"
        "tty"
        "dialout"
        "video"
        "storage-users"
      ];
      shell = pkgs.bash;
      openssh.authorizedKeys.keyFiles = [clan-facts.ssh_public_key];
    };
  };
  nix.settings.allowed-users = ["netsa"];
}
