{
  pkgs,
  clan-facts,
  ...
}: {
  users = {
    users.madi = {
      isNormalUser = true;
      home = "/home/madi";
      description = "madi";
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
      openssh.authorizedKeys.keys = [clan-facts.ssh_public_key];
    };
  };
  nix.settings.allowed-users = ["madi"];
}
