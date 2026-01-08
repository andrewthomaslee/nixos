{
  disko.devices = let
    nvme0n1 = "/dev/disk/by-id/nvme-WD_Blue_SN5100_500GB_25492N805944";
    storage = "/dev/disk/by-id/ata-WDC_WDBNCE0010PNC_184898801017";
    arc = "/dev/disk/by-id/ata-ST2000DX001-1NS164_Z4Z5RFRN";
    san = "/dev/disk/by-id/ata-SanDisk_SD8SBAT256G1122_161808400633";
  in {
    disk = {
      nvme0n1 = {
        name = "nvme0n1";
        device = nvme0n1;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
              priority = 1;
            };
            ESP = {
              type = "EF00";
              size = "1G";
              priority = 2;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            nixos = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = ["noatime"];
              };
            };
          };
        };
      };
      storage = {
        name = "storage";
        device = storage;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            storage = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = ["noatime"];
              };
            };
          };
        };
      };
      arc = {
        name = "arc";
        device = arc;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            arc = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = ["noatime"];
              };
            };
          };
        };
      };
      san = {
        name = "san";
        device = san;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            san = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = ["noatime"];
              };
            };
          };
        };
      };
    };
  };
}
