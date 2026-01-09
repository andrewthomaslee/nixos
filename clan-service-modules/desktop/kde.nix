{ pkgs, ... }:
{
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;

    xrdp = {
      defaultWindowManager = "startplasma-x11";
      enable = true;
      openFirewall = true;
    };

    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ]; # remove xterm
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # KDE
    kdePackages.krunner
    kdePackages.kate
    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
    kdePackages.kcolorchooser # A small utility to select a color
    kdePackages.kolourpaint # Easy-to-use paint program
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdePackages.ktorrent # Powerful BitTorrent client
    kdePackages.kdeplasma-addons # All kind of add-ons to improve your Plasma experience
    kdePackages.filelight # disk usage analyzer
    kdePackages.krfb # Krfb Desktop Sharing (VNC)
    kdePackages.kalk # Calculator
    # Apps

    hardinfo2 # System information and benchmarks for Linux systems
    haruna # Open source video player built with Qt/QML and libmpv
    xclip # Tool to access the X clipboard from a console application
  ];
}
