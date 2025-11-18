{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Core vim options
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true;
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      updatetime = 50;
      signcolumn = "yes";
      clipboard = "unnamedplus";
    };

    # Set leader key
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # Colorscheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = false;
          treesitter = true;
          telescope = {
            enabled = true;
          };
          which_key = true;
        };
      };
    };

    # Plugins
    plugins = {
      # LSP Configuration
      lsp = {
        enable = true;
        servers = {
          # TypeScript/JavaScript
          ts_ls.enable = true;
          # Python
          pyright.enable = true;
          # Go
          gopls.enable = true;
          # Rust
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          # Nix
          nil_ls.enable = true;
          # JSON
          jsonls.enable = true;
          # YAML
          yamlls.enable = true;
          # Bash
          bashls.enable = true;
          # Solidity - enable if you have solc installed
          # solidity.enable = true;
        };
      };

      # Autocompletion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };

      # Treesitter for better syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight = {
            enable = true;
            additional_vim_regex_highlighting = false;
          };
          indent = {
            enable = true;
          };
        };
      };

      # Telescope fuzzy finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native = {
            enable = true;
          };
        };
        settings = {
          defaults = {
            layout_config = {
              horizontal = {
                prompt_position = "top";
              };
            };
            sorting_strategy = "ascending";
          };
        };
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            options = {
              desc = "Find files";
            };
          };
          "<leader>fg" = {
            action = "live_grep";
            options = {
              desc = "Live grep";
            };
          };
          "<leader>fb" = {
            action = "buffers";
            options = {
              desc = "Find buffers";
            };
          };
          "<leader>fh" = {
            action = "help_tags";
            options = {
              desc = "Help tags";
            };
          };
          "<leader>fc" = {
            action = "commands";
            options = {
              desc = "Commands (command palette)";
            };
          };
          "<leader>fk" = {
            action = "keymaps";
            options = {
              desc = "Find keymaps";
            };
          };
          "<leader>gs" = {
            action = "git_status";
            options = {
              desc = "Git status";
            };
          };
          "<leader>gc" = {
            action = "git_commits";
            options = {
              desc = "Git commits";
            };
          };
        };
      };

      # File explorer
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          window = {
            width = 30;
            position = "left";
          };
        };
      };

      # Web devicons (explicitly enable to avoid deprecation warning)
      web-devicons.enable = true;

      # Git integration
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          current_line_blame_opts = {
            delay = 300;
          };
          signs = {
            add = { text = "+"; };
            change = { text = "~"; };
            delete = { text = "_"; };
            topdelete = { text = "‾"; };
            changedelete = { text = "~"; };
          };
        };
      };

      # Status line
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "catppuccin";
            section_separators = {
              left = "";
              right = "";
            };
            component_separators = {
              left = "|";
              right = "|";
            };
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [ "branch" "diff" "diagnostics" ];
            lualine_c = [ "filename" ];
            lualine_x = [ "encoding" "fileformat" "filetype" ];
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };
        };
      };

      # Buffer line for tabs
      bufferline = {
        enable = true;
        settings = {
          options = {
            diagnostics = "nvim_lsp";
            separator_style = "thin";
            show_buffer_close_icons = true;
            show_close_icon = false;
          };
        };
      };

      # Auto pairs
      nvim-autopairs = {
        enable = true;
      };

      # Comment toggling
      comment = {
        enable = true;
      };

      # Indent guides
      indent-blankline = {
        enable = true;
      };

      # Which-key for keybinding hints (command palette!)
      which-key = {
        enable = true;
        settings = {
          delay = 500;
          icons = {
            breadcrumb = "»";
            separator = "➜";
            group = "+";
          };
          spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
              icon = "🔍";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "Git";
              icon = "";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "Code";
              icon = "";
            }
            {
              __unkeyed-1 = "<leader>r";
              group = "Rename";
              icon = "";
            }
          ];
        };
      };

      # Surround text objects
      nvim-surround = {
        enable = true;
      };

      # Better diagnostics list
      trouble = {
        enable = true;
      };
    };

    # Keymaps
    keymaps = [
      # File explorer
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle file explorer";
      }
      # LSP keymaps
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "gD";
        action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
        options.desc = "Go to declaration";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<CR>";
        options.desc = "Go to references";
      }
      {
        mode = "n";
        key = "gi";
        action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
        options.desc = "Go to implementation";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Hover documentation";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "Code action";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        options.desc = "Rename symbol";
      }
      # Diagnostics
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Previous diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next diagnostic";
      }
      {
        mode = "n";
        key = "<leader>d";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Show diagnostic";
      }
      # Buffer navigation
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<CR>";
        options.desc = "Previous buffer";
      }
      # Better window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Move to left window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Move to bottom window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Move to top window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Move to right window";
      }
      # Comment toggle (added explicit keymaps for clarity)
      {
        mode = "n";
        key = "<leader>/";
        action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
        options.desc = "Toggle comment";
      }
      {
        mode = "v";
        key = "<leader>/";
        action = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
        options.desc = "Toggle comment";
      }
    ];

    # Additional Lua configuration
    extraConfigLua = ''
      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
        },
      })

      -- LSP handlers with rounded borders
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = 'rounded' }
      )

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = 'rounded' }
      )

      -- Set up custom filetypes
      vim.filetype.add({
        extension = {
          sol = "solidity",
        },
      })
    '';
  };
}
