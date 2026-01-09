{ pkgs, ... }:
{
  mkEnvGenerator = envs: rec {
    files.envfile = { };
    runtimeInputs = [ pkgs.coreutils ];
    prompts = pkgs.lib.genAttrs envs (name: {
      persist = false;
    });

    # Invalidate on env change
    validation.script = script;

    script = ''
      mkdir -p $out
      cat <<EOT >> $out/envfile
      ${builtins.concatStringsSep "\n" (map (e: "${e}='$(cat $prompts/${e})'") envs)}
      EOT
    '';
  };
}
