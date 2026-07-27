{ config, inputs, pkgs, ... }:

{

  imports = [
    ./modules/neovim.nix
    ./modules/git.nix
    ./modules/flameshot.nix
    ./modules/fish.nix
    ./modules/dunst.nix
    ./modules/wm/kitty.nix
    ./modules/wm/hyprpaper.nix
    ./modules/wm/hyprland.nix
    ./modules/wm/hyprlock.nix
    ./modules/wm/waybar.nix
    ./modules/wm/wlogout.nix
    ./modules/wm/rofi.nix
  ];

  home.username = "boris";
  home.homeDirectory = "/home/boris";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    htop
    tmux
    git
    fastfetch
    inputs.neovim.packages.${pkgs.system}.default
  ];

  programs.home-manager.enable = true;

}
