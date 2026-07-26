{ pkgs, ... }:

{
  
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    hyprpaper
    firefox
    kitty
    hyprlock
    hypridle
    flameshot
    wl-clipboard
    wireplumber
    brightnessctl
    nwg-look
    libnotify
    rofi
    waybar
    dunst
    thunar
    wlogout
    flatpak
    adwaita-icon-theme

    # Програмки
    discord-ptb
    telegram-desktop

    # Разработка 
    gnumake
    gcc
    clang
    cmake
    unzip
    zip
    wget
    curl
    python3
    python3Packages.pip
    python3Packages.virtualenv
    nodejs_22
    corepack
    temurin-bin-21
    maven
    gradle
  ];
  
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans  # Для азиатских символов
      noto-fonts-color-emoji     # Для цветных эмодзи
      font-awesome         # Для иконок (замки, пользователи и др.)

      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.symbols-only # Универсальный пакет только с глифами/иконками
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
	monospace = [ "JetBrainsMono Nerd Font" ];
	sansSerif = [ "Noto Sans" ];
	serif = [ "Noto Serif" ];
	emoji = [ "Noto Color Emoji" ];
      };
    };
  };

}
