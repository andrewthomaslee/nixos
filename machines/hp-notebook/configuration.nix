{lib, ...}: {
  clan-net = {
    filesystems.ext4.enable = true;

    virtualisation = {
      docker.enable = lib.mkForce false;
      virtualbox.enable = lib.mkForce false;
    };
  };
}
