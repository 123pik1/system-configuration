{  ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # 1. Base settings
    opts = {
      number = true; # set number
      cursorline = true; # set cursorline
      mouse = "a"; # set mouse=a
      tabstop = 4; # set tabstop=4
      shiftwidth = 4;
      expandtab = true; # set expandtab
      clipboard = "unnamedplus"; # set clipboard=unnamedplus
      termguicolors = true;
    };

    # 2. Style
    colorschemes.onedark = {
      enable = true;
      settings = {
        style = "darker";
        transparent = false;
        diagnostics = {
          darker = true;
          undercurl = true;
        };
      };
    };

    diagnostic.settings = {
        virtualLines.enable = true;
        virtualText = true;
        signs = true;
        underline = true;
        updateInInsert = true;
        severity_sort = true;
    };

    # 3. Keybinds
    globals.mapleader = " "; # let mapleader = " "

    keymaps = [
      # Saving
      {
        mode = "n";
        key = "<C-s>";
        action = "<cmd>w<CR>";
      }
      {
        mode = "i";
        key = "<C-s>";
        action = "<Esc><cmd>w<CR>a";
      }

      { mode = "n"; key = "<C-q>"; action = "<cmd>q!<CR>"; }
      { mode = "i"; key = "<C-q>"; action = "<Esc><cmd>q!<CR>"; }

      # NvimTree
      {
        mode = "n";
        key = "<C-b>";
        action = "<cmd>NvimTreeToggle<CR>";
      }
      {
        mode = "i";
        key = "<C-b>";
        action = "<Esc><cmd>NvimTreeToggle<CR>";
      }

      # Navigation
      {
        mode = "n";
        key = "<A-,>";
        action = "<cmd>tabprevious<CR>";
      }
      {
        mode = "n";
        key = "<A-.>";
        action = "<cmd>tabnext<CR>";
      }
      {
        mode = "n";
        key = "<leader>m";
        action = "<cmd>MarkdownPreviewToggle<CR>";
        options.desc = "Toggle Markdown Preview";
      }
    ];

    autoCmd = [
      {
        event = "BufWritePre"; # Wyzwól tuż przed zapisaniem pliku
        pattern = [ 
          "*.py" "*.nix" "*.sh" "*.lua" "*.cpp" "*.c" 
          "*.vhdl" "*.html" "*.ts" "*.js" "*.java" "*.svelte" "*.vhd"
          "*.rs"
        ];
        callback = {
          __raw = "function() vim.lsp.buf.format({ async = false }) end";
        };
      }
    ];

    # 4. Plugins
    plugins = {

      web-devicons.enable = true;

      render-markdown.enable = true;

      markdown-preview = {
        enable = true;
        settings = {
            auto_start =0;
            theme = "dark";
        };
      };

      treesitter = {
        enable = true;
        settings.ensure_installed = ["markdown" "markdown_inline" "mermaid"];
      };

      lualine = {
        enable = true;
        settings.options.theme = "onedark";
      };

      nvim-tree = {
        enable = true;
        settings = {
            filters.dotfiles = false;
            git.enable = true;
    
            on_attach = {
            __raw = ''
            function(bufnr)
                local api = require('nvim-tree.api')
            
          
                api.config.mappings.default_on_attach(bufnr)
            
         
                vim.keymap.set('n', '<CR>', api.node.open.tab, { buffer = bufnr, desc = "Otworz w nowym Tabie" })
            end
            '';
        };

   };
      

      };

      comment.enable = true;
      nvim-autopairs.enable = true;


        # lsp for rust
        rustaceanvim = {
            enable = true;
        };

        crates = {
            enable = true;
        };

      # 5. LSP
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          pyright.enable = true;
          clangd.enable = true;
          bashls.enable = true;
          html.enable = true;
          cssls.enable = true;
          ts_ls.enable = true;
          vhdl_ls.enable = true;
          
        };



        # format keybind
        keymaps = {
            diagnostic = {
                "<leader>e" = "open_float";
                "[d" = "goto_prev";    
                "]d" = "goto_next";
            };

            lspBuf = {
                "<C-f>" = "format";
                "K" = "hover";             
                "gd" = "definition";       
                # Space + a - code action
                "<leader>ca" = "code_action";
                "<leader>rn" = "rename";
            };
        };
      };

      # 6. Autocompletion
      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<Tab>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping.select_next_item()";
            "<Down>" = "cmp.mapping.select_next_item()";
            "<Up>" = "cmp.mapping.select_prev_item()";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "crates"; }
          ];
        };
      };
    };
  };
}
