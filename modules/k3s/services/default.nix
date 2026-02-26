{...}: {
  imports = [
    ./traefik.nix
    ./longhorn.nix
    ./argo-cd.nix
    ./cilium.nix
  ];
}
