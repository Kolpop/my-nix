{ config, pkgs, ... }:

{

  services.gvfs.enable = true;

  services.udisks2.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

}
