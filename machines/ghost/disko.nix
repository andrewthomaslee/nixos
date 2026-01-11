{
  disko.devices = {
    disk = {
      # --- Main 512GB Drive (nvme1n1) ---
      nvme0n1 = {
        name = "main";
        device = "/dev/nvme1n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            "boot" = {
              size = "10M";
              type = "EF02";
              priority = 1;
            };
            # EFI System Partition (ESP)
            ESP = {
              type = "EF00"; # GPT type for an EFI partition
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            # Root partition for NixOS
            root = {
              size = "100%"; # Use the rest of the drive
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

      # --- Swap 32GB Drive (nvme0n1) ---
      nvme1n1 = {
        name = "swap";
        device = "/dev/nvme0n1";
        type = "disk";
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
  };
}
