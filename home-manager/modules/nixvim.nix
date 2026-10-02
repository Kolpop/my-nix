{
programs.nixvim = {
  enable = true;

  keymaps = [
    {
      mode = "i";          # Режим Insert (вставки)
      key = "jk";          # Что нажимаем
      action = "<Esc>";    # Что происходит (выход в Normal режим)
      options = {
	silent = true;     # Не выводить команду в консоль внизу
	noremap = true;    # Запретить рекурсивный маппинг
      };
    }

    {
      mode = "n";                   # Режим Normal
      key = "<leader>e";            # Сочетание клавиш (обычно Пробел + e или \ + e)
      action = ":Neotree toggle left reveal<CR>"; # Команда: открыть/закрыть слева и показать текущий файл
      options = {
	silent = true;
	desc = "Открыть проводник файлов";
      };
    }
  ];

  plugins = {
    neo-tree = {
      enable = true;
      enableGitStatus = true;       # Показывать измененные Git файлы
      closeIfLastWindow = true;     # Закрыть Neovim, если остался только проводник
      
      window = {
	width = 30;                 # Ширина панели слева (в символах)
	position = "left";          # Закрепить слева
      };
    };

    web-devicons.enable = true;

    cmp = {
      enable = true;
      settings.sources = [ { name = "nvim_lsp"; } ];
    };

    lsp = {
      enable = true;
      keymaps = {
	silent = true;
	lspBuf = {
	  gd = "definition";
	  K = "hover";
	};
      };
      servers = {
	nil_ls.enable = true;
	pyright.enable = true;
      };
    };
  };

  globals.mapleader = " "; 
};
}
