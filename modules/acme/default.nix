{
  config,
  lib,
  clan-facts,
  clan-net-utils,
  ...
}: let
  cfg = config.clan-net.services.acme.cloudflare;

  makeCert = domain: {
    ${domain} = {
      domain = "*.${domain}";
      inheritDefaults = true;
    };
  };
  makeCerts = domains: builtins.listToAttrs (builtins.map makeCert domains);
in {
  options.clan-net.services.acme.cloudflare = {
    enable = lib.mkEnableOption "Cloudflare DNS via ACME";
  };

  config = lib.mkIf cfg.enable {
    clan.core.vars.generators."amce" = clan-net-utils.mkEnvGenerator [
      "CLOUDFLARE_DNS_API_TOKEN"
    ];
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = clan-facts.email;
        group = "nginx";
        dnsResolver = "1.1.1.1:53";
        dnsProvider = "cloudflare";
        # location of your CLOUDFLARE_DNS_API_TOKEN=[value]
        # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#EnvironmentFile=
        environmentFile = config.clan.core.vars.generators."acme".files."envfile".path;
      };
      certs = makeCerts clan-facts.cloudflare.domains;
    };
  };
}
