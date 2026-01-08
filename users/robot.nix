{
  pkgs,
  clan-facts,
  ...
}: {
  users = {
    users.robot = {
      isNormalUser = true;
      home = "/home/robot";
      description = "robot";
      extraGroups = [
        "users"
      ];
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [clan-facts.ssh_public_key];
    };
  };
  nix.settings.allowed-users = ["robot"];
}
