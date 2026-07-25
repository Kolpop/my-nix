{ config, pkgs, ... }:

{

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.ly.enable = true;

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

}
