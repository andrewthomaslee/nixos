{
  _class = "clan.service";
  manifest.name = "desktop";
  manifest.readme = "Desktop environment/wayland compositor setup";

  roles = {
    kde = {
      perInstance.nixosModule = ./kde.nix;
      description = "KDE/Plasma (wayland): Full-featured desktop environment with modern Qt-based interface";
    };
  };
}
