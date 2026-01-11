{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.clan-net.virtualisation;
in {
  options.clan-net.virtualisation = {
    docker.enable = mkEnableOption "Docker virtualisation";
    virtualbox.enable = mkEnableOption "VirtualBox virtualisation";
  };

  config = mkMerge [
    (mkIf cfg.docker.enable {
      users.users.netsa.extraGroups = ["docker"];
      virtualisation.docker.enable = true;
    })

    (mkIf cfg.virtualbox.enable {
      users.extraGroups.vboxusers.members = ["netsa"];
      virtualisation.virtualbox.host.enable = true;
      # virtualisation.virtualbox.host.enableKvm = true;
      # virtualisation.virtualbox.host.addNetworkInterface = false;
      # virtualisation.virtualbox.host.enableExtensionPack = true;
    })
  ];
}
