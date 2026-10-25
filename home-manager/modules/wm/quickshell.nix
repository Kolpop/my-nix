{ inputs, lib, pkgs, ... }:

let
  quickshellSource = inputs.quickshell-hyprland;

  # Copy upstream QML into a writable user directory. The Nix store itself
  # is immutable, while the shell settings UI may need to write config files.
  quickshellConfig = pkgs.runCommand "quickshell-hyprland-config" {
    nativeBuildInputs = [ pkgs.gnused ];
  } ''
    mkdir -p "$out"
    cp -r \${quickshellSource}/.config/quickshell/. "$out/"
    chmod -R u+w "$out"

    # Upstream files contain paths for the original maintainer.
    grep -rlZ '/home/stopnope/.config/quickshell' "$out" \\
      | xargs -0 -r sed -i \\
          's|/home/stopnope/.config/quickshell|/home/boris/.config/quickshell|g'
    grep -rlZ '/home/stopnope/.local/bin' "$out" \\
      | xargs -0 -r sed -i \\
          's|/home/stopnope/.local/bin|/home/boris/.local/bin|g'
  '';
in
{
  home.packages = with pkgs; [
    quickshell
    python3
    jq
    grim
    slurp
    wl-clipboard
    cliphist
    brightnessctl
    playerctl
    libnotify
    rsync
  ];

  home.activation.installQuickshellConfig =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p "$HOME/.config/quickshell"

      # Seed missing files without overwriting settings changed by the user.
      $DRY_RUN_CMD \${pkgs.rsync}/bin/rsync -a --ignore-existing \\
        \${quickshellConfig}/ "$HOME/.config/quickshell/"

      $DRY_RUN_CMD mkdir -p "$HOME/.local/bin"
      if [ ! -e "$HOME/.local/bin/screenshot.sh" ]; then
        $DRY_RUN_CMD install -m 755 \\
          \${quickshellSource}/.local/bin/screenshot.sh \\
          "$HOME/.local/bin/screenshot.sh"
      fi
    '';
}
