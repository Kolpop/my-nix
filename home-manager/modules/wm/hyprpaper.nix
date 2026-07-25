{ config, pkgs, ... }:

{

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/home/boris/Downloads/Wallpapers/nix-Wallpaper.png" ];
      wallpaper = [
        {
          monitor = "eDP-1";
	  path = "/home/boris/Downloads/Wallpapers/nix-Wallpaper.png";
        } 
      ];
    };
  };

}
