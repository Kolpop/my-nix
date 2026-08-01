{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      set number
      set relativenumber
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set termguicolors

      let mapleader = " "
      inoremap jk <ESC>
      nnoremap <leader>h :nohlsearch<CR>
      nnoremap <leader>e :NvimTreeToggle<CR>

      augroup VsnipSetup
        autocmd!
        autocmd VimEnter * let g:vsnip_snippet_dirs = [
        \ expand('~/.config/vsnip'),
        \ '${pkgs.vimPlugins.friendly-snippets}/share/vim-plugins/friendly-snippets'
        \ ]
      augroup END

      imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
      smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
      imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
      smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

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

  home.file = {
    ".config/vsnip/python.json".text = ''
      {
        "main_block": {
          "prefix": "main",
          "body": [
            "if __name__ == '__main__':",
            "    $0"
          ],
          "description": "Create python main block"
        }
      }
    '';

    ".config/vsnip/javascript.json".text = ''
      {
        "console_log": {
          "prefix": "clg",
          "body": [
            "console.log($0);"
          ],
          "description": "Log to console"
        }
      }
    '';

    ".config/vsnip/html.json".text = ''
      {
        "html5_boilerplate": {
          "prefix": "html5",
          "body": [
            "<!DOCTYPE html>",
            "<html lang=\"en\">",
            "<head>",
            "    <meta charset=\"UTF-8\">",
            "    <title>''${1:Document}</title>",
            "</head>",
            "<body>",
            "    $0",
            "</body>",
            "</html>"
          ],
          "description": "HTML5 boilerplate structure"
        }
      }
    '';
  };
}

