{
  disko.devices = {
    disk = {
      usb = {
        device = "/dev/disk/by-id/usb-TONPHA_USB_2.0_Classic_52312-0:0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ENFAIN = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/mnt/EFAIN";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}
