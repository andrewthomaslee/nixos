{
  lib,
  clan-facts,
  ...
}: let
  userPrograms = {
    clan-net.programs = {
      k9s.enable = true;
      go.enable = true;
      python.enable = true;
    };
  };
in {
  home-manager.users.root = userPrograms;
  home-manager.users.netsa = userPrograms;

  clan-net = {
    filesystems.ext4.enable = true;
    secrets.enable = true;

    defaults = {
      storagebox = {
        mountOnAccess = lib.mkForce false;
        concurrency = 3;
      };
    };

    services = {
      hugo = {
        enable = true;
        blogAndrewleeFun.enable = true;
      };
    };
  };

  services.qemuGuest.enable = true;

  networking = let
    interface = clan-facts.networking.public.interface.hel-1;
  in {
    defaultGateway6 = {
      address = "fe80::1";
      inherit interface;
    };
    interfaces.${interface} = {
      useDHCP = true;
      ipv6.addresses = [
        {
          address = "2a01:4f9:c014:9b2::1";
          prefixLength = 64;
        }
      ];
    };
  };
}
