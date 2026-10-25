{
  pkgs,
  ...
}: {
  # Hyprland 0.55+ uses ~/.config/hypr/hyprland.lua.
  wayland.windowManager.hyprland.enable = true;

  # The Lua source is kept next to this Nix module and deployed by Home Manager.
  home.file.".config/hypr/hyprland.lua".source = ./hyprland.lua;

  home.pointerCursor = {
    gtk.enable = true;
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
