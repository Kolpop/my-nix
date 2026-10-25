-- Hyprland 0.55+ Lua configuration
-- Managed declaratively by Nix/Home Manager.
-- Quickshell replaces Waybar; all Quickshell integration stays here.

local mainMod = "SUPER"
local home = os.getenv("HOME") or ""
local screenshotsDir = home .. "/Downloads"

-- Monitor
hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})

-- General, decoration and input settings
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border = "rgba(fefffcff)",
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 6,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 0.95,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "0xee1a1a1a",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    input = {
        kb_layout = "us, ru",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
    },
})

-- Quickshell layer effects from the upstream installer
hl.layer_rule({ match = { namespace = "quickshell" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ match = { namespace = "quickshell-dock" }, no_anim = true })
hl.layer_rule({ match = { namespace = "lockscreen" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true, ignore_alpha = 0.1 })

-- Start Quickshell and Clipse when Hyprland starts
hl.on("hyprland.start", function()
    hl.exec_cmd("quickshell -d -p " .. home .. "/.config/quickshell")
    hl.exec_cmd("clipse -listen")
end)

-- Applications (original actions retained; conflicting bindings moved)
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("rofi -show drun || pkill rofi"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("flameshot gui -p " .. screenshotsDir))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("kitty --class clipse -e clipse"))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("code"))

-- Window management
hl.bind(mainMod .. " + C", hl.dsp.window.close(), { locked = true })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Scratchpad (Super+S toggles; modified move binding avoids screenshot shortcut)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + CTRL + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Workspace switching with Super+Ctrl+mouse wheel (Quickshell owns plain Super+wheel)
hl.bind(mainMod .. " + CTRL + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with Super + left/right mouse buttons
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia and brightness keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Quickshell IPC bindings from StopNope/quickshell-hyprland
local qsPipe = 'echo "%s" > "$XDG_RUNTIME_DIR/qs.pipe"'
local function qsCommand(command)
    return hl.dsp.exec_cmd(string.format(qsPipe, command))
end

hl.bind(mainMod .. " + G", qsCommand("toggle_settings"))
hl.bind(mainMod .. " + U", qsCommand("toggle_side"))
hl.bind(mainMod .. " + L", qsCommand("lock"))
hl.bind(mainMod .. " + N", qsCommand("toggle_menu:wifi"))
hl.bind(mainMod .. " + B", qsCommand("toggle_menu:bt"))
hl.bind(mainMod .. " + E", qsCommand("toggle_menu:eth"))
hl.bind(mainMod .. " + R", qsCommand("toggle_launcher"))
hl.bind(mainMod .. " + SPACE", qsCommand("toggle_launcher"))
hl.bind(mainMod .. " + V", qsCommand("toggle_clipboard"))
hl.bind("ALT + TAB", qsCommand("switcher_next"))
hl.bind("ALT + SHIFT + TAB", qsCommand("switcher_prev"))
hl.bind("ALT_L", qsCommand("switcher_commit"), { release = true })
hl.bind("ALT_R", qsCommand("switcher_commit"), { release = true })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(home .. "/.local/bin/screenshot.sh"))
hl.bind("Print", hl.dsp.exec_cmd(home .. "/.local/bin/screenshot.sh"))

-- VxWM spatial desktop controller
local vxwm = "python3 " .. home .. "/.config/quickshell/scripts/vxwm_controller.py "
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(vxwm .. "toggle"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd(vxwm .. "toggle_clamp"))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.exec_cmd(vxwm .. "pan 250 0"), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.exec_cmd(vxwm .. "pan -250 0"), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.exec_cmd(vxwm .. "pan 0 200"), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.exec_cmd(vxwm .. "pan 0 -200"), { repeating = true })
hl.bind(mainMod .. " + mouse_up", hl.dsp.exec_cmd(vxwm .. "pan 0 160"))
hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_cmd(vxwm .. "pan 0 -160"))
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.exec_cmd(vxwm .. "pan 180 0"))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.exec_cmd(vxwm .. "pan -180 0"))
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd(vxwm .. "zoom_in"))
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd(vxwm .. "zoom_out"))
hl.bind(mainMod .. " + 0", hl.dsp.exec_cmd(vxwm .. "zoom_reset"))
hl.bind(mainMod .. " + ALT + mouse_up", hl.dsp.exec_cmd(vxwm .. "zoom_in"))
hl.bind(mainMod .. " + ALT + mouse_down", hl.dsp.exec_cmd(vxwm .. "zoom_out"))

-- Numbered workspaces
for i = 1, 10 do
    local key = i % 10
    local modifier = i == 10 and (mainMod .. " + CTRL + ") or (mainMod .. " + ")
    local moveModifier = i == 10 and (mainMod .. " + CTRL + SHIFT + ") or (mainMod .. " + SHIFT + ")
    hl.bind(modifier .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(moveModifier .. key, hl.dsp.window.move({ workspace = i }))
end
