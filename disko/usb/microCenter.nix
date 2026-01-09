{
  disko.devices = {
    disk = {
      usb = {
        device = "/dev/disk/by-id/usb-_USB_DISK_3.0_070807029C907132-0:0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            microCenter = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/mnt/microCenter";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}