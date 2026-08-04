{ pkgs, inputs, ... }: {
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    # игры
    inputs.prismalauncher.packages.${pkgs.system}.prismlauncher

    # Основная хуйня
    vim
    wget
    curl
    wl-clipboard
    wireplumber
    brightnessctl
    nwg-look
    libnotify
    dunst
    wlogout
    flatpak
    adwaita-icon-theme
    julia
    unzip
    zip
    cliphist
    clipse
    steam-run
    pavucontrol

    # CLI чтобы повыебываться
    hollywood
    genact
    cmatrix
    cbonsai
    btop
    cava

    # Hyprland
    waybar
    rofi
    hyprlock
    hypridle
    hyprpaper

    # Програмки
    telegram-desktop
    firefox
    thunar
    kitty
    flameshot
    discord-ptb

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
      noto-fonts-cjk-sans # Для аниме девочек
      noto-fonts-color-emoji # Для смайликов
      font-awesome # иконки

      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.symbols-only # Хуйня
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
