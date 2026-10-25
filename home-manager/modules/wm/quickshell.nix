{ inputs, lib, pkgs, ... }:

let
  quickshellSource = inputs.quickshell-hyprland;

  # Stage a clean, writable config from the pinned upstream source.
  quickshellConfig = pkgs.runCommand "quickshell-hyprland-config" {
    nativeBuildInputs = [ pkgs.findutils pkgs.gnused ];
  } ''
    mkdir -p "$out"
    cp -r ${quickshellSource}/.config/quickshell/. "$out/"
    chmod -R u+w "$out"
    find "$out" -type f -exec sed -i \
      -e 's|/home/stopnope/.config/quickshell|/home/boris/.config/quickshell|g' \
      -e 's|/home/stopnope/.local/bin|/home/boris/.local/bin|g' {} +
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
    psmisc
    coreutils
    findutils
    fontconfig
    imagemagick
  ];

  home.activation.installQuickshellConfig =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p "$HOME/.config"

      # Keep a one-time backup, then deploy the pinned tree exactly.
      if [ -d "$HOME/.config/quickshell" ] && [ ! -e "$HOME/.config/quickshell.nix-backup" ]; then
        $DRY_RUN_CMD mv "$HOME/.config/quickshell" "$HOME/.config/quickshell.nix-backup"
      else
        $DRY_RUN_CMD rm -rf "$HOME/.config/quickshell"
      fi
      $DRY_RUN_CMD mkdir -p "$HOME/.config/quickshell"
      $DRY_RUN_CMD ${pkgs.rsync}/bin/rsync -a --delete ${quickshellConfig}/ "$HOME/.config/quickshell/"

      $DRY_RUN_CMD mkdir -p "$HOME/.local/bin"
      $DRY_RUN_CMD install -m 755 ${quickshellSource}/.local/bin/screenshot.sh "$HOME/.local/bin/screenshot.sh"
      $DRY_RUN_CMD find "$HOME/.config/quickshell" -type f \( -name "*.py" -o -name "*.sh" \) -exec chmod u+x {} +
    '';

  fonts.fontconfig.enable = true;
  home.file.".local/share/fonts/quickshell".source = "${quickshellSource}/.config/quickshell/fonts";
}
