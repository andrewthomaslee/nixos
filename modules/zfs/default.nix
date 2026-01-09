{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.clan-net.filesystems.zfs;
in
{
  options.clan-net.filesystems.zfs.enable = lib.mkEnableOption "ZFS support";

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators.zfs = {
      files = {
        hostId = {
          secret = false;
        };
      };
      runtimeInputs = with pkgs; [ coreutils ];
      script = ''
        head -c4 /dev/urandom | od -A none -t x4 | tr -d ' \n' > $out/hostId
      '';
    };

    environment.systemPackages = with pkgs; [
      zstd
      lz4
      zfs
      zfsbackup
      e2fsprogs
      xfsprogs
    ];

    systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];

    networking.hostId = "${config.clan.core.vars.generators.zfs.files.hostId.value}";
    boot = {
      loader = {
        systemd-boot.enable = lib.mkDefault false;
        grub = {
          enable = lib.mkDefault true;
          efiInstallAsRemovable = true;
          zfsSupport = true;
          efiSupport = true;
        };
      };
      supportedFilesystems = [ "zfs" ];
      zfs = {
        forceImportRoot = false;
        package = pkgs.zfs;
      };
    };
    services.zfs = {
      autoScrub = {
        enable = true;
        interval = "weekly";
      };
      autoSnapshot = {
        enable = true;
        flags = "-k -p --utc";
      };
      trim = {
        enable = true;
        interval = "weekly";
      };
    };
  };
}
