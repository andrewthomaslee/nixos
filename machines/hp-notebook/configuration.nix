{
  lib,
  flake-self,
  ...
}: {
  clan-net = {
    filesystems.ext4.enable = true;
    services.networking.enable = lib.mkForce false;
    virtualisation = {
      docker.enable = lib.mkForce false;
      virtualbox.enable = lib.mkForce false;
    };
  };
  home-manager.users.madi = flake-self.homeConfigurations.madi;
}
