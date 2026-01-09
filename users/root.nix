{ clan-facts, ... }:
{
  users.users.root.openssh.authorizedKeys.keys = [ clan-facts.ssh_public_key ];

  # Allow to run nix
  nix.settings.allowed-users = [ "root" ];
}
