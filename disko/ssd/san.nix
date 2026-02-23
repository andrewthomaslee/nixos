{
  disko.devices = {
    disk = {
      san = {
        name = "san";
        device = "/dev/disk/by-id/ata-SanDisk_SD8SBAT256G1122_161808400633";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            storage = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/mnt/san";
                mountOptions = [
                  "noatime"
                  "nofail"
                ];
              };
            };
          };
        };
      };
    };
  };
}
