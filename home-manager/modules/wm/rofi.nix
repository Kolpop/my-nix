{ pkgs, lib, config, ... }: { # Добавили config в аргументы

  programs.rofi = lib.mkForce {
    enable = true;
    package = pkgs.rofi; 

    extraConfig = {
      modi = "drun";
      icon-theme = "Numix-Circle";
      font = "JetBrains Mono Regular 13";
      show-icons = true;
      terminal = "wezterm";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      sidebar-mode = true;
      border-radius = 5;
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg-col = mkLiteral "#1e1e2e";
        bg-col-light = mkLiteral "#1e1e2e";
        border-col = mkLiteral "#1e1e2e";
        selected-col = mkLiteral "#313244";
        blue = mkLiteral "#89b4fa";
        fg-col = mkLiteral "#cdd6f4";
        fg-col2 = mkLiteral "#f38ba8";
        grey = mkLiteral "#6c7086";
        teal = mkLiteral "#94e2d5";
        width = 600;
        border-radius = 15;
      };

      "element-text, element-icon, mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "window" = {
        height = 360;
        border = 2;
        border-color = mkLiteral "#ffffff";
        background-color = mkLiteral "@bg-col";
        # Добавлено: внутренний отступ для всего окна, чтобы контент не прилипал к рамке
        padding = 20; 
      };

      "mainbox" = {
        background-color = mkLiteral "@bg-col";
	spacing = 20;
      };

      "inputbar" = {
        children = [ "prompt" "entry" ];
        background-color = mkLiteral "@bg-col";
        border-radius = 5;
        padding = 2;
	margin = [ 0 0 15 0 ];
      };

      "prompt" = {
        background-color = mkLiteral "@blue";
        padding = 6;
        text-color = mkLiteral "@bg-col";
        border-radius = 3;
        margin = [ 20 0 0 20 ];
      };

      "textbox-prompt-colon" = {
        expand = false;
        str = ":";
      };

      "entry" = {
        padding = 6;
        margin = [ 20 0 0 10 ];
        text-color = mkLiteral "@fg-col";
        background-color = mkLiteral "@bg-col";
      };

      "listview" = {
        border = [ 0 0 0 ];
        padding = [ 6 0 0 ];
        margin = [ 10 0 0 25 ];
        columns = 2;
        lines = 5;
        background-color = mkLiteral "@bg-col";
      };

      "element" = {
        # Исправлено: добавлены боковые внутренние отступы (8px сверху/снизу, 12px слева/справа)
        padding = [ 8 12 8 12 ]; 
        # Добавлено: небольшое расстояние между элементами списка
        margin = [ 2 4 2 4 ];    
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@fg-col";
        # Добавлено: скругление для выделяемой плашки элемента
        border-radius = 6;       
      };

      "element-icon" = {
        size = 25;
        # Добавлено: отступ между иконкой и текстом приложения
        margin = [ 0 10 0 0 ]; 
      };

      "element selected" = {
        background-color = mkLiteral "@selected-col";
        text-color = mkLiteral "@teal";
      };

      "mode-switcher" = {
        spacing = 0;
      };

      "button" = {
        padding = 10;
        background-color = mkLiteral "@bg-col-light";
        text-color = mkLiteral "@grey";
        vertical-align = "0.5";
        horizontal-align = "0.5";
      };

      "button selected" = {
        background-color = "@bg-col";
        text-color = "@blue";
      };

      "message" = {
        background-color = mkLiteral "@bg-col-light";
        margin = 2;
        padding = 2;
        border-radius = 5;
      };

      "textbox" = {
        padding = 6;
        margin = [ 20 0 0 20 ];
        text-color = mkLiteral "@blue";
        background-color = mkLiteral "@bg-col-light";
      };
    };
  };

  home.packages = with pkgs; [
    numix-icon-theme-circle
    nerd-fonts.jetbrains-mono
  ];
}

