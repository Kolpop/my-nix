{ config, pkgs, ... }: {

  # 1. Установка Neovim и сопутствующих системных утилит
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      tree-sitter       
      trash-cli         
      git               
      gcc               
      gnumake           
      ripgrep           
      fd                
      ghostscript       
      mermaid-cli       
    ];
  };

  # 2. Декларативное создание init.lua с исправленными путями Lua
  xdg.configFile."nvim/init.lua".text = ''
    -- Решаем проблемы с runtimepath на NixOS
    vim.opt.rtp:prepend(vim.fn.stdpath("config"))
    vim.opt.rtp:append(vim.fn.stdpath("data") .. "/site")

    -- Автоматическое скачивание lazy.nvim при старте
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = "https://github.com"
      local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
      end
    end
    
    -- ИСПРАВЛЕНИЕ: Добавляем lazy.nvim в runtimepath и package.path, чтобы require("lazy") сработал
    vim.opt.rtp:prepend(lazypath)
    package.path = package.path .. ";" .. lazypath .. "/lua/?.lua;" .. lazypath .. "/lua/?/init.lua"

    -- Настройка lazy.nvim с фиксами для NixOS
    require("lazy").setup({
      spec = {
        -- Инициализация дистрибутива LazyVim
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- Импорт ваших кастомных плагинов из созданного ниже модуля
        { import = "plugins" },
      },
      defaults = {
        lazy = false,
        version = false, 
      },
      -- Защита от read-only system: уносим lockfile в изменяемую директорию data
      lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
      
      -- Отключаем luarocks, который гарантированно ломается на NixOS
      rocks = {
        hererocks = false,
        enabled = false,
      },
      install = { colorscheme = { "tokyonight", "habamax" } },
      checker = { enabled = true }, 
    })

    -- Перенос файла конфигурации LazyVim в изменяемую директорию
    vim.g.lazyvim_json_path = vim.fn.stdpath("data") .. "/lazyvim.json"
  '';

  # 3. Декларативное создание модуля plugins
  xdg.configFile."nvim/lua/plugins/config.lua".text = ''
    return {
      -- Сюда можно добавлять плагины или кастомизировать настройки LazyVim
    }
  '';
}

