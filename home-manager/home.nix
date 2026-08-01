{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
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
    (inputs.nyanvim.packages.${pkgs.system}.default.override {
      # Отключаем встроенный плагин Copilot
      categories = {
        copilot = false;
        general = true;
        neonew = true;
      };

      settings =
        (prev.settings or {})
        // {
          disable_copilot = true;
        };

      # Добавляем необходимые вам системные LSP-серверы
      extraPackages = [
        pkgs.lua-language-server # LSP для Lua
        pkgs.nil # LSP для Nix
        pkgs.pyright # LSP для Python
        pkgs.nodePackages.typescript-language-server # LSP для TS/JS
      ];

      neovimRC =
        (prev.neovimRC or "")
        + ''
          -- Ждем полной загрузки плагинов и отключаем Copilot встроенным методом
          vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted", -- Или "VeryLazy" в зависимости от структуры nyanvim
            callback = function()
              pcall(function()
                vim.cmd("Copilot disable")
              end)
            end,
          })
        '';
    })
  ];

  programs.home-manager.enable = true;
}
