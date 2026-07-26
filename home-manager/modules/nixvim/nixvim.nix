{ pkgs, config, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Опции редактора описываются как обычный Nix-аттрибут
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      splitright = true;
      splitbelow = true;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;
    };

    # Настройка Leader-клавиши
    globals.mapleader = " ";

    # Горячие клавиши в формате Nix
    keymaps = [
      {
        mode = "i";
        key = "jk";
        action = "<ESC>";
      }
      {
        mode = "n";
        key = "<leader>h";
        action = ":nohlsearch<CR>";
      }
    ];

    # Включение и автонастройка плагинов одной строкой
    colorschemes.tokyonight.enable = true;

    plugins = {
      telescope.enable = true;
      nvim-tree.enable = true;
      treesitter.enable = true;

      # Настройка полноценного LSP без Lua и без Mason
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true; # LSP для самого Nix
          pyright.enable = true; # LSP для Python (если нужен)
        };
      };
    };
  };
}

