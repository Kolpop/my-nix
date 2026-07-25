{ config, pkgs, ... }:

{
  
  programs.hyprlock = {
    enable = true;

    settings = {
      background = [
	{
	  monitor = "";
	  path = "/home/boris/Downloads/Wallpapers/wallpaperflare.com_wallpaper.jpg"; # Укажите ваш путь к картинке
	  blur_passes = 0;
	}
      ];

      label = [
	# ДАТА
	{
	  monitor = "";
	  text = "cmd[update:43200000] echo \"$(date +\"%A, %B %d\")\"";
	  color = "rgba(255, 255, 255, 0.7)";
	  font_size = 14;
	  font_family = "JetBrains Mono";
	  position = "0, 410";
	  halign = "center";
	  valign = "center";
	}
	# ЧАСЫ
	{
	  monitor = "";
	  text = "$TIME";
	  color = "rgba(255, 255, 255, 1.0)";
	  font_size = 90;
	  font_family = "Steelfish Extrabold";
	  position = "0, 320";
	  halign = "center";
	  valign = "center";
	  shadow_passes = 1;
	  shadow_range = 2;
	}
	# ИМЯ ПОЛЬЗОВАТЕЛЯ
	{
	  monitor = "";
	  text = " $USER";
	  color = "rgba(255, 255, 255, 0.8)";
	  font_size = 12;
	  font_family = "JetBrains Mono";
	  position = "0, -100";
	  halign = "center";
	  valign = "center";
	}
      ];

      "input-field" = [
	{
	  monitor = "";
	  size = "220, 45";
	  outline_thickness = 0;
	  dots_size = 0.2;
	  dots_spacing = 0.2;
	  dots_center = true;
	  outer_color = "rgba(0, 0, 0, 0)";
	  inner_color = "rgba(255, 255, 255, 0.1)";
	  font_color = "rgba(255, 255, 255, 0.8)";
	  fade_on_empty = false;
	  placeholder_text = "   Enter Pass";
	  hide_input = false;
	  position = "0, -150";
	  halign = "center";
	  valign = "center";
	}
      ];
    };
  };

}
