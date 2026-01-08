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
    virt-manager.enable = mkEnableOption "Virt-Manager virtualisation";
  };

  config = mkMerge [
    (mkIf cfg.docker.enable {
      users.users.netsa.extraGroups = ["docker"];
      virtualisation.docker.enable = true;
    })

    (mkIf cfg.virt-manager.enable {
      boot.kernelModules = ["kvm-amd"];
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
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
