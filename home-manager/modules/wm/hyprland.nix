{ pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      -- Example special workspace (scratchpad)
      hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
      hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

      -- Scroll through existing workspaces with mainMod + scroll
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

      -- Move/resize windows with mainMod + LMB/RMB and dragging
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Laptop multimedia keys for volume and LCD brightness
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
      hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

      -- Requires playerctl
      hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
      
      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

      hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
    '';

    settings = {
      
      mainMod = { _var = "SUPER"; };
      browser = { _var = "firefox"; };
      terminal = { _var = "kitty"; };
      launcher = { _var = "rofi -show drun || pkill rofi"; };
      provodnic = { _var = "thunar"; };      
      
      screenshots_dir = { _var = "~/Downloads"; };
      
      on = {
        _args = [
          "hyprland.start"
	  (lib.generators.mkLuaInline "function()\n  hl.exec_cmd(\"waybar\")\nend")
	];
      };

      monitor = [
        {
          output = "eDP-1";
	  mode = "1920x1080@60";
	  position = "0x0";
	  scale = 1;
	}
      ];

      config = [
        { 
	  general = {
            gaps_in  = 5;
            gaps_out = 20;

            border_size = 2;

            col = {
               active_border   = "rgba(fefffcff)";
               inactive_border = "rgba(595959aa)";
            };

            resize_on_border = false;

            allow_tearing = false;

            layout = "dwindle";
	  };
	  decoration = {
            rounding       = 6;
            rounding_power = 2;

            active_opacity   = 1.0;
            inactive_opacity = 0.95;

            shadow = {
              enabled      = true;
              range        = 4;
              render_power = 3;
              color        = "0xee1a1a1a";
            };

            blur = {
              enabled   = true;
              size      = 3;
              passes    = 1;
              vibrancy  = 0.1696;
            };
          };
          input = {
            kb_layout = "us, ru";
	    kb_options = "grp:alt_shift_toggle";
	    follow_mouse = 1;
	  };
	}
      ];

      bind = lib.lists.flatten [
      
        {
	  _args = [
            "SUPER + Q"
	    (lib.generators.mkLuaInline "hl.dsp.exec_cmd(terminal)")
	  ];
	}
        
        {
          _args = [
            "SUPER + B"
	    (lib.generators.mkLuaInline "hl.dsp.exec_cmd(browser)")
	  ];
        }

	{
	  _args = [
            "SUPER + R"
	    (lib.generators.mkLuaInline "hl.dsp.exec_cmd(launcher)")
	  ];
        }

        {
	  _args = [
            "SUPER + SPACE"
	    (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprlock\")")
	  ];
        }

	{
	  _args = [
            "SUPER + E"
	    (lib.generators.mkLuaInline "hl.dsp.exec_cmd(provodnic)")
	  ];
        }

        {
	  _args = [
            "SUPER + L"
	    (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"flameshot gui -p \" .. screenshots_dir)")
	  ];
        }

        {
          _args = [
            "SUPER + C"
	    (lib.generators.mkLuaInline "hl.dsp.window.close()")
	    { locked = true; }
	  ];
	}
        
        (builtins.genList (x: 
          let
     	    ws = x + 1;
	    modResult = ws - (ws / 10) * 10;
   	    key = builtins.toString modResult;
          in
	  [
	    { _args = [ (lib.generators.mkLuaInline "mainMod .. \" + \" .. \"${key}\"") (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = ${builtins.toString ws} })") ]; }
            { _args = [ (lib.generators.mkLuaInline "mainMod .. \" + SHIFT + \" .. \"${key}\"") (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = ${builtins.toString ws} })") ]; }
	  ]
        ) 10)


      ];

    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
}

