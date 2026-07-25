{ config, pkgs, ... }:

{
  # Включаем Waybar через Home Manager
  programs.waybar = {
    enable = true;

    # Главные настройки панели (генерирует config.jsonc)
    settings = {
      mainBar = { 
      
        layer = "top";
        position = "top";
        spacing = 0;
        height = 34;

        modules-left = [
          "custom/logo"
          "hyprland/workspaces"
        ];
        
        modules-center = [
          "clock"
        ];
        
        modules-right = [
          "tray"
          "memory"
          "network"
          "wireplumber"
          "battery"
          "custom/power"
        ];

        "wlr/taskbar" = {
          format = "{icon}";
          on-click = "activate";
          on-click-right = "fullscreen";
          icon-theme = "WhiteSur";
          icon-size = 25;
          tooltip-format = "{title}";
        };

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            "default" = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "active" = "󱓻";
            "urgent" = "󱓻";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
        };

        "memory" = {
          interval = 5;
          format = "󰍛 {}%";
          max-length = 10;
        };

        "tray" = {
          spacing = 10;
        };

        "clock" = {
          tooltip-format = "{calendar}";
          format-alt = "  {:%a, %d %b %Y}";
          format = "  {:%I:%M %p}";
        };

        "network" = {
          format-wifi = "{icon}";
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-ethernet = "󰀂";
          format-alt = "󱛇";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{icon} {essid}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "󰀂{ifname}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 5;
          nospacing = 1;
        };

        "wireplumber" = {
          format = "{icon}";
          format-bluetooth = "󰂰";
          nospacing = 1;
          tooltip-format = "Volume : {volume}%";
          format-muted = "󰝟";
          format-icons = {
            headphone = "";
            default = [ "󰖀" "󰕾" " " ];
          };
          on-click = "pamixer -t";
          scroll-step = 1;
        };

        "custom/logo" = {
          format = "  ";
          tooltip = false;
        };

        "battery" = {
          format = "{capacity}% {icon}";
          format-icons = {
            charging = [
              "󰢜"
	      "󰂆"
	      "󰂇"
	      "󰂈"
	      "󰢝"
	      "󰂉"
	      "󰢞"
	      "󰂊"
	      "󰂋"
	      "󰂅"
	    ];
            default = [
              "󰁺"
	      "󰁻"
	      "󰁼"
	      "󰁽"
	      "󰁾"
	      "󰁿"
	      "󰂀"
	      "󰂁"
	      "󰂂"
	      "󰁹"
	    ];
          };
          format-full = "Charged ";
          interval = 5;
          states = {
            warning = 20;
            critical = 10;
          };
          tooltip = false;
        };

        "custom/power" = {
          format = "󰤆";
          tooltip = false;
          on-click = "wlogout";
        };

      };
    };

    # Стилизация панели (генерирует style.css)
    style = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      font-family: JetBrainsMono Nerd Font;
      font-size: 13px;
    }

    window#waybar {
      margin-top: 100px;
      background-color: transparent;
    }

    window#waybar.hidden {
      opacity: 0.5;
    }

    #workspaces {
      background-color: transparent;
    }

    #workspaces button {
      all: initial;
      /* Remove GTK theme values (waybar #1351) */
      min-width: 0;
      /* Fix weird spacing in materia (waybar #450) */
      box-shadow: inset 0 -3px transparent;
      /* Use box-shadow instead of border so the text isn't offset */
      padding: 6px 18px;
      margin: 10px 3px;
      border-radius: 4px;
      background-color: #1e1e2e;
      color: #cdd6f4;
    }

    #workspaces button.active {
      color: #1e1e2e;
      background-color: #cdd6f4;
    }

    #workspaces button.urgent {
      background-color: #f38ba8;
    }

    #memory,
    #custom-power,
    #battery,
    #backlight,
    #wireplumber,
    #network,
    #clock,
    #tray {
      border-radius: 4px;
      margin: 10px 3px;
      padding: 6px 12px;
      background-color: #1e1e2e;
      color: #cdd6f4;
    }

    #custom-power {
      margin-right: 18px;
      color: #f38ba8;
    }

    #custom-logo {
      padding-right: 7px;
      padding-left: 7px;
      margin-left: 5px;
      font-size: 15px;
      border-radius: 8px 0px 0px 8px;
      color: #1793d1;
    }

    #clock { 
      font-family: JetBrainsMono Nerd Font;
    }

    tooltip {
      border-radius: 8px;
      padding: 15px;
      background-color: #131822;
    }

    tooltip label {
      padding: 5px;
      background-color: #131822;
    }
    '';
  };

  # Дополнительно: устанавливаем шрифты Nerd Fonts для иконок в баре
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}

