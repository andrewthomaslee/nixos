{pkgs, ...}: {
  mkEnvGenerator = envs: rec {
    files.envfile = {};
    runtimeInputs = [pkgs.coreutils];
    prompts = pkgs.lib.genAttrs envs (name: {
      persist = false;
    });

    # Invalidate on env change
    validation.script = script;

    script = ''
      mkdir -p $out
      cat <<EOT >> $out/envfile
      ${builtins.concatStringsSep "\n" (map (e: "${e}=$(cat $prompts/${e})") envs)}
      EOT
    '';
  };

  # Generates a YAML file from a nix attribute set
  writeYamlFile = name: config:
    with pkgs;
      stdenv.mkDerivation {
        name = name;
        buildInputs = [json2yaml]; # Use a tool for conversion
        src = writeText "${name}.json" (builtins.toJSON config); # Start with JSON string
        buildCommand = ''
          json2yaml "$src" > "$out"
        '';
      };

  # Generates a password and hash for clan.core.vars.generators
  mkPasswordHashGenerator = name: {
    share = true;
    files = {
      password.deploy = false;
      hash.secret = false;
    };
    runtimeInputs = with pkgs; [apacheHttpd openssl];
    script = ''
      mkdir -p $out/
      echo "$(openssl rand -hex 64)" > $out/password
      htpasswd -cBb $out/hash ${name} "$(cat $out/password)"
    '';
  };

  # move a file to the k3s server manifests directory
  moveToManifests = name: path: {
    "sops2manifests-${name}" = {
      description = "move secrets to /var/lib/rancher/k3s/server/manifests/";
      wantedBy = ["multi-user.target"];
      after = ["k3s.service"];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.rsync}/bin/rsync -a ${path} /var/lib/rancher/k3s/server/manifests/";
      };
    };
  };
}
