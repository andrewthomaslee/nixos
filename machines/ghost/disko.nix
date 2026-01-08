{lib, ...}: {
  boot.loader.systemd-boot.enable = lib.mkForce true;
  boot.loader.grub.enable = lib.mkForce false;

  disko.devices = let
    nvme0n1 = "/dev/disk/by-id/nvme-eui.5cd2e475228a0100";
    nvme1n1 = "/dev/disk/by-id/nvme-eui.5cd2e47911b0139e";
  in {
    disk = {
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
      nvme0n1 = {
        type = "disk";
        device = nvme0n1;
        content = {
          type = "gpt";
          partitions = {
            k3s = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/rancher/k3s";
                mountOptions = ["noatime"];
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
          mountpoint = "none";
          atime = "off";
        };
        datasets = {
          "root" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/secret.key";
            };
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
        };
      };
    };
  };
}
