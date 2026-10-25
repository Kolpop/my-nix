# Quickshell on NixOS

This branch integrates [StopNope/quickshell-hyprland](https://github.com/StopNope/quickshell-hyprland) declaratively into the `Kolpop/my-nix` NixOS/Home Manager configuration.

## Design

- `flake.nix` pins the upstream repository as a non-flake input.
- `home-manager/modules/wm/quickshell.nix` installs Quickshell and runtime dependencies, stages the pinned QML tree into `~/.config/quickshell`, installs the screenshot helper, and installs the upstream fonts.
- On first activation the previous `~/.config/quickshell` is preserved as `~/.config/quickshell.nix-backup`. Subsequent activations refresh the runtime config from the pinned source, removing stale files.
- `home-manager/modules/wm/hyprland.lua` contains the Hyprland 0.55+ Lua config, original window/input settings, Quickshell layer rules, startup, and keybindings.
- `home-manager/modules/wm/hyprland.nix` enables Hyprland and deploys `hyprland.lua`; it retains cursor and GTK settings.
- Waybar is no longer imported by Home Manager because Quickshell provides the panel. The old `waybar.nix` module is kept in the repository but is not activated.
- The upstream installer and self-updater are not run: they edit files outside Nix's declarative management. To update the upstream source intentionally, update the `quickshell-hyprland` flake input, then rebuild.

## Build and apply

From the local checkout:

```sh
nix flake lock
sudo nixos-rebuild build --flake .#AZERTY
```

After a successful build:

```sh
sudo nixos-rebuild switch --flake .#AZERTY
```

Then log out and back into Hyprland (or restart the session) to load the new Lua configuration and panel.

## Notes

- Existing user edits to the old Quickshell folder are preserved in the one-time backup; the deployed config follows the pinned upstream revision.
- The original application shortcuts that conflict with Quickshell are moved to modified combinations. Quickshell receives its upstream default shortcuts; workspace 10 uses Ctrl with Super to avoid colliding with Quickshell's Super+0 zoom reset.
- This branch was updated through GitHub and has not been built on the user's machine. Always run `build` before `switch`.
