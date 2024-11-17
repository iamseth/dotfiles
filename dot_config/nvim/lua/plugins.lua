-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
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
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "github/copilot.vim" },
    { "tpope/vim-commentary" },
    { "kdheepak/lazygit.nvim" },
    { "airblade/vim-gitgutter" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/popup.nvim" },
    { "MunifTanjim/nui.nvim" }, 
    { "nvim-lua/plenary.nvim" },

    { "projekt0n/github-nvim-theme",
      config = function()
        vim.cmd("colorscheme github_dark_default")
      end
    },

    { "ray-x/go.nvim",
      config = function()
        require("go").setup()
      end
    },

    { "stevearc/oil.nvim",
      config = function()
        require("oil").setup({
          default_file_explorer = true,
          preview = {
           update_on_cursor_moved = true,
          },
          columns = {
            "icon",
            "size",
            "mtime",
            "permissions",
          },
          view_options = {
            show_hidden = true,
          }
        })
      end
    },

    { "nvim-lualine/lualine.nvim",         
      config = function()
        require('lualine').setup({
          options = {
            theme = 'github_dark_default',
            globalstatus = true,
            icons_enabled = true,
          },
        })
      end
    },

    { "nvim-telescope/telescope.nvim",
      config = function()
        local actions = require("telescope.actions")
        require('telescope').setup({
          defaults = {
            mappings = {
              i = { ["<esc>"] = actions.close },
            }
          }
        })
      end
    },

    { "folke/noice.nvim",
      config = function()
        require("noice").setup({
          presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = false,
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false,  -- add a border to hover docs and signature help
          },
          routes = { { filter = { event = "msg_show", kind = "", find = "written", }, opts = { skip = true }}}
        })
      end
    },

    { "rcarriga/nvim-notify",
      config = function()
        vim.notify = require("notify")
        require("notify").setup({
          stages = "static",
          timeout = 3000
        })
      end,
    },

    { "neovim/nvim-lspconfig",
      config = function()
        require("lspconfig").gopls.setup({
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
            }
          }
        })
      end
    },

    { "nvim-treesitter/nvim-treesitter",
      config = function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = { "go", "lua", "vim", "vimdoc", "query",
                               "markdown", "markdown_inline", "regex",
                               "python", "bash", "json", "yaml", "dockerfile",
                               "gowork", "gomod", "gosum", "sql", "gotmpl",
                               "comment" },
          sync_install = true,
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          }
        })
      end
    }

  }
})
