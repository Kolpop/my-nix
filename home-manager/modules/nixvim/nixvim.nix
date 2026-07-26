{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Конфигурация в виде строк (без Lua-файлов)
    extraConfig = ''
      set number          " Номера строк
      set relativenumber  " Относительные номера строк
      set tabstop=4       " Табуляция в 4 пробела
      set shiftwidth=4    " Размер отступа
      set expandtab       " Табы -> пробелы
      set splitright      " Вертикальный сплит справа
      set termguicolors   " 24-битный цвет

      " Классические горячие клавиши Vimscript
      let mapleader = " "
      inoremap jk <ESC>
      nnoremap <leader>h :nohlsearch<CR>
    '';

    # Плагины берутся напрямую из вашего текущего nixpkgs
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim       # Тема оформления
      nvim-treesitter.withAllGrammars # Подсветка синтаксиса
      telescope-nvim        # Поиск по файлам
      nvim-tree-lua         # Дерево файлов
    ];

    # Системные пакеты, нужные для работы плагинов
    extraPackages = with pkgs; [
      ripgrep
      fd
      git
    ];
  };
}

