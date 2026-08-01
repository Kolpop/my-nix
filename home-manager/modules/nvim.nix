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

      nil                         
      nixfmt-rfc-style            
      lua-language-server         
      pyright                     
      typescript-language-server 
      vscode-langservers-extracted 
      
      jdk                         
      jdt-language-server         
      maven                       
      gradle                      
      vscode-extensions.vscjava.vscode-java-debug
      vscode-extensions.vscjava.vscode-java-test  
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

  xdg.configFile."nvim/lua/config/keymaps.lua".text = ''
    local map = vim.keymap.set

    -- === Навигация между окнами (splits) без Ctrl+W ===
    map("n", "<C-h>", "<C-w>h", { desc = "Перейти в левое окно" })
    map("n", "<C-j>", "<C-w>j", { desc = "Перейти в нижнее окно" })
    map("n", "<C-k>", "<C-w>k", { desc = "Перейти в верхнее окно" })
    map("n", "<C-l>", "<C-w>l", { desc = "Перейти в правое окно" })

    -- === Управление размерами окон (Alt + Стрелочки) ===
    map("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Увеличить высоту окна" })
    map("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Уменьшить высоту окна" })
    map("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Уменьшить ширину окна" })
    map("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Увеличить ширину окна" })

    -- === Переключение между вкладками сверху (Bufferline / Табы) ===
    map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Предыдущий буфер" })
    map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Следующий буфер" })
    map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Закрыть текущий буфер" })

    -- === Быстрое разделение экрана (Сплиты) ===
    map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Разделить вертикально" })
    map("n", "<leader>s", "<cmd>split<cr>", { desc = "Разделить горизонтально" })

    -- === Перемещение строк в визуальном режиме (как в VS Code) ===
    -- Выделите текст через Shift+V и двигайте его с помощью Alt+j / Alt+k
    map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Переместить выделенную строку вниз" })
    map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Переместить выделенную строку вверх" })

    -- === Разное для удобства ===
    map("i", "jk", "<ESC>", { desc = "Быстрый выход из режима вставки в нормальный режим" })
    map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Очистить подсветку поиска" })
  '';

  # 3. Декларативное создание модуля plugins
  xdg.configFile."nvim/lua/plugins/config.lua".text = ''
    return {
      { "williamboman/mason.nvim", enabled = false },
      { "williamboman/mason-lspconfig.nvim", enabled = false },

      {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            nil_ls = {}, lua_ls = {}, pyright = {}, ts_ls = {}, html = {}, cssls = {},
          },
        },
      },

      {
        "mfussenegger/nvim-jdtls",
        opts = function()
          local java_debug_path = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug"
          local java_test_path = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test"
          local bundles = {}
          local debug_jar = vim.fn.glob(java_debug_path .. "/server/com.microsoft.java.debug.plugin-*.jar", true)
          if debug_jar ~= "" then table.insert(bundles, debug_jar) end
          local test_jars = vim.fn.glob(java_test_path .. "/server/*.jar", true, true)
          for _, jar in ipairs(test_jars) do
            if not vim.endswith(jar, "com.microsoft.java.test.runner-jar-with-dependencies.jar") then
              table.insert(bundles, jar)
            end
          end
          return {
            cmd = { "jdtls" },
            root_dir = require("jdtls.setup").find_root({ ".git", "pom.xml", "build.gradle" }),
            init_options = { bundles = bundles },
          }
        end,
      },

      -- === ДОБАВЛЕНИЕ СНИППЕТОВ ===
      -- В дистрибутиве LazyVim плагин native-snippets или LuaSnip автоматически 
      -- подхватит базу friendly-snippets, как только она будет установлена.
      { "rafamadriz/friendly-snippets" },
    }
  '';
}


