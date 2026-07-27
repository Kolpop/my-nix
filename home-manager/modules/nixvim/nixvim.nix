{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      set number
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set termguicolors

      let mapleader = " "
      inoremap jk <ESC>
      nnoremap <leader>h :nohlsearch<CR>
      nnoremap <leader>e :NvimTreeToggle<CR>

      function! StartNixLsp()
        if executable('nil')
          lua vim.lsp.start({ name = 'nil', cmd = {'nil'} })
        endif
      endfunction

      function! StartPythonLsp()
        if executable('pyright-langserver')
          lua vim.lsp.start({ name = 'pyright', cmd = {'pyright-langserver', '--stdio'} })
        endif
      endfunction

      function! StartJsLsp()
        if executable('typescript-language-server')
          lua vim.lsp.start({ name = 'ts_ls', cmd = {'typescript-language-server', '--stdio'} })
        endif
      endfunction

      function! StartHtmlCssLsp()
        if executable('vscode-html-language-server')
          lua vim.lsp.start({ name = 'html', cmd = {'vscode-html-language-server', '--stdio'} })
        endif
      endfunction

      function! StartJavaLsp()
        if executable('jdtls')
          lua vim.lsp.start({ name = 'jdtls', cmd = {'jdtls'} })
        endif
      endfunction

      autocmd FileType nix call StartNixLsp()
      autocmd FileType python call StartPythonLsp()
      autocmd FileType javascript,typescript call StartJsLsp()
      autocmd FileType html call StartHtmlCssLsp()
      autocmd FileType css call StartHtmlCssLsp()
      autocmd FileType java call StartJavaLsp()

      nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap K  <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>

      lua << EOF
      require('lualine').setup({ options = { theme = 'tokyonight' } })
      require('gitsigns').setup()
      require('ibl').setup()
      require('nvim-tree').setup({ sync_root_with_cwd = true, respect_buf_cwd = true, update_focused_file = { enable = true, update_root = true } })
      EOF
    '';

    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      nvim-treesitter.withAllGrammars
      telescope-nvim
      lualine-nvim
      nvim-web-devicons
      gitsigns-nvim
      indent-blankline-nvim
      nvim-tree-lua
      vim-vsnip
      vim-snippets
      friendly-snippets
    ];

    extraPackages = with pkgs; [
      ripgrep
      fd
      git
      nil
      pyright
      typescript-language-server
      vscode-langservers-extracted
      jdt-language-server
    ];
  };

}

