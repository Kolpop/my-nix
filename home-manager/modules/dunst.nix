{ config, pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_color = "#cad3f5";
        separator_color = "frame";
        font = "JetBrains Mono Regular 11";
        corner_radius = 10;
        
        # Исправлено под современный синтаксис (X, Y)
        offset = "(5, 5)";
        
        origin = "top-right";
        notification_limit = 8;
        gap_size = 7;
        frame_width = 2;
        width = 300;
        
        # Исправлено под современный синтаксис (min, max) для сохранения динамической высоты
        height = "(0, 100)";
        
        follow = "keyboard";
      };

      urgency_low = {
        background = "#24273A";
        foreground = "#CAD3F5";
      };

      urgency_normal = {
        background = "#24273A";
        foreground = "#CAD3F5";
      };

      urgency_critical = {
        background = "#24273A";
        foreground = "#CAD3F5";
        frame_color = "#F5A97F";
      };
    };
  };
}

