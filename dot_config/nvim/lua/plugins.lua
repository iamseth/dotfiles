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

    -- GitHub Copilot for Neovim
    { "github/copilot.vim" },

    -- Comment stuff out
    { "tpope/vim-commentary" },

    -- LazyGit is a simple terminal UI for git commands
    { "kdheepak/lazygit.nvim" },

    -- Put Git info in the gutter
    { "airblade/vim-gitgutter" },

    -- devicons
    { "nvim-tree/nvim-web-devicons" },

    -- Popup API
    { "nvim-lua/popup.nvim" },

    -- UI library
    { "MunifTanjim/nui.nvim" }, 

    -- util functions
    { "nvim-lua/plenary.nvim" },

    -- A color scheme for neovim inspired by GitHub
    { "projekt0n/github-nvim-theme",
      config = function()
        vim.cmd("colorscheme github_dark_default")
      end
    },

    -- A modern and minimalistic file explorer
    { "ray-x/go.nvim",
      config = function()
        require("go").setup()
      end
    },

    -- A file explorer for neovim written in lua
    { "stevearc/oil.nvim",
      config = function()
        require("oil").setup({
          default_file_explorer = true,
          preview = {
           update_on_cursor_moved = true,
          },
          columns = {
            "icon",
            "permissions",
            "size",
            "mtime",
          },
          view_options = {
            show_hidden = true,
          }
        })
      end
    },

    -- A blazing fast statusline written in pure lua
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

    -- A highly extendable fuzzy finder over lists
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

    --  A replacement UI for Neovim
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

    -- A modern notification plugin for neovim
    { "rcarriga/nvim-notify",
      config = function()
        vim.notify = require("notify")
        require("notify").setup({
          stages = "static",
          timeout = 3000
        })
      end,
    },

    -- A simple plugin to toggle the terminal in neovim
    { "akinsho/toggleterm.nvim",
      config = function()
        require("toggleterm").setup()
      end
    },

    -- A simple plugin to toggle the terminal in neovim
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

    -- Treesitter configurations and abstraction layer
    { "nvim-treesitter/nvim-treesitter",            -- Treesitter configurations and abstraction layer
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
    },
  },
})
