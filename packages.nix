{ pkgs, inputs, ... }: {
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  services.flatpak.enable = true;

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  programs.vscode = {
    enable = true;

  };

  environment.systemPackages = with pkgs; [
    # игры
    inputs.prismalauncher.packages.${pkgs.system}.prismlauncher
    temurin-bin-25

    # Основная хуйня
    ocl-icd
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
    qbittorrent
    wine

    # Утилиты для аудита Wi-Fi и работы с Hashcat
    hashcat
    aircrack-ng
    hcxtools
    hcxdumptool
    iw

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
    figma-linux
    discord-ptb
    gnome-pomodoro 

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
