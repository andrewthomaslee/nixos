{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.clan-net.programs.k9s;
in
{
  options.clan-net.programs.k9s.enable = mkEnableOption "k9s kubernetes CLI";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kubefetch
      kubernetes-helm
      kubectl
      argocd
      kompose
    ];
    home.sessionVariables = {
      K9S_SKIN = "dracula";
    };
    programs = {
      k9s = {
        enable = true;
        skins.dracula = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/derailed/k9s/refs/heads/master/skins/dracula.yaml";
          sha256 = "10is0kb0n6s0hd2lhyszrd6fln6clmhdbaw5faic5vlqg77hbjqs";
        };
      };
      kubeswitch = {
        enable = true;
        commandName = "kswitch";
        settings = {
          kind = "SwitchConfig";
          version = "v1alpha1";
          kubeconfigName = "*.config";
          kubeconfigStores = [
            {
              kind = "filesystem";
              kubeconfigName = "*.config";
              paths = [
                "~/.kube/"
              ];
            }
          ];
        };
      };
    };
  };
}
