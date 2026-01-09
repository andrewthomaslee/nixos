{
  lib,
  config,
  ...
}:
let
  cfg = config.clan-net.filesystems.ext4;
in
{
  options.clan-net.filesystems.ext4.enable = lib.mkEnableOption "ext4 support";

  config = lib.mkIf cfg.enable {
    boot.loader.grub.enable = lib.mkDefault true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.efiInstallAsRemovable = true;
  };
}
