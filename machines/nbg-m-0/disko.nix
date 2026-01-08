{
  disko.devices = let
    nvme0n1 = "/dev/disk/by-id/nvme-SAMSUNG_MZQLB960HAJR-00007_S437NA0N209177";
    nvme1n1 = "/dev/disk/by-id/nvme-SAMSUNG_MZQLB960HAJR-00007_S437NA0N209180";
  in {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = nvme0n1;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
              priority = 1;
            };
            ESP = {
              size = "1G";
              type = "EF00";
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
      nvme1n1 = {
        type = "disk";
        device = nvme1n1;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
              priority = 1;
            };
            ESP = {
              size = "1G";
              type = "EF00";
              priority = 2;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot-fallback";
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
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "lz4";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
          atime = "off";
        };
        datasets = {
          "root" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "root/nixos" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "/";
          };
          "root/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            "com.sun:auto-snapshot" = "false";
            options.mountpoint = "/nix";
          };
          "root/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "/home";
          };
          "root/tmp" = {
            type = "zfs_fs";
            mountpoint = "/tmp";
            "com.sun:auto-snapshot" = "false";
            options = {
              mountpoint = "/tmp";
              sync = "disabled";
            };
          };
          "root/k3s" = {
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
    };
  };
}
