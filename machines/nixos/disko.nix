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
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
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
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zstorage";
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
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zarc";
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
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zsan";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "lz4";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
        };
        datasets = {
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };
          "nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };
          "home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };
          "k3s" = {
            type = "zfs_volume";
            size = "150G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var/lib/rancher/k3s";
              mountOptions = ["noatime"];
            };
            options.volblocksize = "4k";
          };
        };
      };
      zstorage = {
        type = "zpool";
        rootFsOptions = {
          compression = "lz4";
          acltype = "posixacl";
          xattr = "sa";
        };
        datasets = {
          "main" = {
            type = "zfs_fs";
            mountpoint = "/mnt/storage";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };
        };
      };
      zarc = {
        type = "zpool";
        rootFsOptions = {
          compression = "lz4";
          acltype = "posixacl";
          xattr = "sa";
        };
        datasets = {
          "main" = {
            type = "zfs_fs";
            mountpoint = "/mnt/arc";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };
        };
      };
      zsan = {
        type = "zpool";
        rootFsOptions = {
          compression = "lz4";
          acltype = "posixacl";
          xattr = "sa";
        };
        datasets = {
          "main" = {
            type = "zfs_fs";
            mountpoint = "/mnt/san";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };
        };
      };
    };
  };
}
