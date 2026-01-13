# ---
# schema = "single-disk"
# [placeholders]
# mainDisk = "/dev/disk/by-id/mmc-TY2964_0x5aebfa8a" 
# ---
# This file was automatically generated!
# CHANGING this configuration requires wiping and reinstalling the machine
{

  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.enable = true;
  disko.devices = {
    disk = {
      main = {
        name = "main-edf12d4fc0244694be3be21771ca6f14";
        device = "/dev/disk/by-id/mmc-TY2964_0x5aebfa8a";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            "boot" = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 1;
            };
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
