# Quickshell on NixOS

This branch adds an initial Home Manager integration of
[StopNope/quickshell-hyprland](https://github.com/StopNope/quickshell-hyprland)
to the existing \`Kolpop/my-nix\` configuration.

## Design

- The upstream repository is added as a non-flake input in \`flake.nix\`.
- \`home-manager/modules/wm/quickshell.nix\` installs Quickshell and the
  listed runtime dependencies, then seeds \`~/.config/quickshell\`.
- QML/config files are copied to the home directory so they are not executed
  directly from the immutable Nix store.
- The upstream installer is not run because it edits Hyprland config outside
  Nix/Home Manager.
- Existing Waybar startup and keybindings are left unchanged for now, so this
  branch does not yet replace Waybar or fully migrate the upstream shortcuts.

## Build and test

From the local checkout:

\`\`\`sh
nix flake lock
sudo nixos-rebuild build --flake .#AZERTY
\`\`\`

If the build succeeds, apply it with:

\`\`\`sh
sudo nixos-rebuild switch --flake .#AZERTY
\`\`\`

Test Quickshell manually before adding autostart:

\`\`\`sh
quickshell -d -p "$HOME/.config/quickshell"
\`\`\`

## Status

This is an initial migration scaffold, not a verified one-click migration.
QML may need further path fixes or runtime dependencies. The build and manual
runtime test must pass before replacing Waybar or changing existing shortcuts.
