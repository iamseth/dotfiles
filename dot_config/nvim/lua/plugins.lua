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
    { "tpope/vim-commentary" },
    { "kdheepak/lazygit.nvim" },
    { "airblade/vim-gitgutter" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/popup.nvim" },
    { "MunifTanjim/nui.nvim" }, 
    { "nvim-lua/plenary.nvim" },
    { "MeanderingProgrammer/render-markdown.nvim" },
    { "tomasky/bookmarks.nvim",
      config = function()
        require('bookmarks').setup {
          save_file = vim.fn.expand "$HOME/.bookmarks",
          keywords =  {
            ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
            ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
            ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
            ["@n"] = " ", -- mark annotation startswith @n ,signs this icon as `Note`
          },
          on_attach = function(bufnr)
            local bm = require "bookmarks"
            local map = vim.keymap.set
            map("n","mm",bm.bookmark_toggle) -- add or remove bookmark at current line
            map("n","mi",bm.bookmark_ann) -- add or edit mark annotation at current line
            map("n","mc",bm.bookmark_clean) -- clean all marks in local buffer
            map("n","mn",bm.bookmark_next) -- jump to next mark in local buffer
            map("n","mp",bm.bookmark_prev) -- jump to previous mark in local buffer
            map("n","ml",bm.bookmark_list) -- show marked file list in quickfix window
            map("n","mx",bm.bookmark_clear_all) -- removes all bookmarks
          end
        }
      end
    },

    { "smjonas/inc-rename.nvim", config = function() require("inc_rename").setup() end },

    {
      "Wansmer/treesj",
      keys = { { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
      opts = { use_default_keymaps = false, max_join_length = 150 },
    },

    { "zbirenbaum/copilot.lua",
      opts = { filetypes = { ["*"] = true } },
      config = function()
        require('copilot').setup({
           suggestion = {
             auto_trigger = true,             
             keymap = {
               accept_word = false,
               accept_line = false,
               accept = "<S-Tab>",
             },
          },
        })
      end

    },

    { "CopilotC-Nvim/CopilotChat.nvim", opts = { show_help = false } },

    { "projekt0n/github-nvim-theme",
      config = function()
        vim.cmd("colorscheme github_dark_default")
      end
    },

    { "ray-x/go.nvim", 
      ft = {"go", 'gomod'},
      event = {"CmdlineEnter"},
      build = ':lua require("go.install").update_all_sync()',
      config = function()
        require("go").setup({
          run_in_floaterm = { enable = true },
        })

      end
    },

    { "ray-x/guihua.lua" },
      

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
            pickers = {
              find_files = { theme = "ivy" },
              live_grep = { theme = "ivy" },
              buffers = { theme = "ivy" },
              lsp_document_symbols = { theme = "dropdown" },
            },
            defaults = {
              mappings = {
                i = { ["<esc>"] = actions.close },
                n = { ["<esc>"] = actions.close },
                -- map ctrl+v to open in vertical split
                i = { ["<C-v>"] = actions.select_vertical },
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
        require("lspconfig").solargraph.setup({
          cmd = { "solargraph", "stdio" },
          filetypes = { "ruby" },
          root_dir = require("lspconfig.util").root_pattern("Gemfile", ".git"),
          settings = {
            solargraph = {
              diagnostics = true,
              completion = true,
              formatting = true,
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
    },


    { "stevearc/overseer.nvim",
      opts = {}, 
      config = function()
        require("overseer").setup({
          default_view = "split",
        }) 
      end
    }


  }
})
