{ pkgs, ... }: {
  # Включаем и настраиваем тему globally или локально
  catppuccin.enable = true;
  catppuccin.flavor = "frappe"; # варианты: "latte", "frappe", "macchiato", "mocha"
  
  catppuccin.hyprlock = {
    enable = false;
  };

  catppuccin.gtk.icon.enable = false;

  programs.kitty = {
    enable = true;
    # Модуль catppuccin-nix автоматически подставит нужный файл темы для kitty
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12.0;
      window_padding_width = 25;
      confirm_os_window_close = 0;
    };
  };
}
