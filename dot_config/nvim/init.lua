-- Author: iamseth
-- Description: Neovim configuration file
-- Usage: Place this file in ~/.config/nvim/init.lua
--       Run :PackerInstall to install plugins
--       Run :PackerUpdate to update plugins
--       Run :PackerSync to sync plugins
--       Run :PackerClean to clean up plugins
-- Keymaps:
--       ; - enter command mode
--       ' - enter shell command mode
--       <leader>s - save all buffers
--       ff - find files using telescope
--       fg - grep through files
--       fb - list open buffers
--       <leader>gg - open lazygit
--       <leader>gf - open file under cursor
--       <leader>_ - increase window height
--       <leader>+ - increase window height
--       <leader>- - increase window width
--       <leader>= - increase window width
--       - - open oil

-- Plugins to install

require('packer').startup(function(use)
  use "wbthomason/packer.nvim"                      -- packer is a package manager for neovim
  use "github/copilot.vim"                          -- AI coding
  use "tpope/vim-commentary"                        -- Plugin that allows you to comment stuff out
  use "folke/tokyonight.nvim"                       -- colorscheme
  use "kdheepak/lazygit.nvim"                       -- Plugin to quickly open up a lazygit instance from within neovim
  use "airblade/vim-gitgutter"                      -- shows a git diff in the gutter (sign column) and stages/undoes hunks
  use "stevearc/oil.nvim"                           -- A file explorer for neovim
  use "nvim-tree/nvim-web-devicons"                 -- Adds file type icons to neovim
  use "nvim-lualine/lualine.nvim"                   -- Fast and easy to configure neovim statusline
  use { "nvim-telescope/telescope.nvim",            -- A highly extendable fuzzy finder over lists
    requires = {
      "nvim-lua/plenary.nvim",                      -- Utility functions
      "nvim-treesitter/nvim-treesitter",            -- Treesitter configurations and abstraction layer
    }
  }
  use { "folke/noice.nvim",                         --  A replacement UI for Neovim
    requires = {
      "MunifTanjim/nui.nvim",                       -- A UI library for Neovim
      "rcarriga/nvim-notify"                        -- A fancy notification manager for neovim
    }
  }
  use {  "epwalsh/obsidian.nvim",                   -- A neovim plugin for the Obsidian.md note taking app
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "notes",
          path = "~/Documents/notes"
        }
      }
    })
  end
  }
end)

-- Configure Plugins

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

require("noice").setup({
  presets = {
    bottom_search = true,                            -- use a classic bottom cmdline for search
    command_palette = false,
    long_message_to_split = true,                    -- long messages will be sent to a split
    inc_rename = false,                              -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false,                                                   -- add a border to hover docs and signature help
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
  },
})

require("notify").setup({
  stages = "static",
  timeout = 3000,
})


local actions = require("telescope.actions")
require('telescope').setup({
  defaults = {
    mappings = {
      i = { ["<esc>"] = actions.close },
      },
    },
})


require('lualine').setup({
  options = {
    theme = 'tokyonight',
    globalstatus = true,
    icons_enabled = true,
  },
})


require('nvim-treesitter.configs').setup({
  ensure_installed = { "go", "lua", "vim", "vimdoc", "query",
                       "markdown", "markdown_inline", "regex",
                       "python", "bash", "json", "yaml", "dockerfile" },
  sync_install = true,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})


-- Settings

vim.opt.tabstop = 2                                                           -- insert 2 spaces for a tab
vim.opt.wrap = false                                                          -- display lines as one long line
vim.opt.ruler = false                                                         -- hide the line and column number of the cursor position
vim.opt.cmdheight = 1                                                         -- more space in the neovim command line for displaying messages
vim.opt.scrolloff = 8                                                         -- minimal number of screen lines to keep above and below the cursor
vim.opt.number = true                                                         -- set numbered lines
vim.opt.backup = false                                                        -- creates a backup file
vim.opt.pumheight = 10                                                        -- pop up menu heigt
vim.opt.laststatus = 3                                                        -- only the last window will always have a status line
vim.opt.shiftwidth = 2                                                        -- the number of spaces inserted for each indentation
vim.opt.showcmd = false                                                       -- hide (partial) command in the last line of the screen (for performance)
vim.opt.mouse = "anicr"                                                       -- allow the mouse to be used in neovim
vim.opt.numberwidth = 4                                                       -- minimal number of columns to use for the line number {default 4}
vim.opt.sidescrolloff = 8                                                     -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.hlsearch = true                                                       -- highlight all matches on previous search pattern
vim.opt.conceallevel = 0                                                      -- so that `` is visible in markdown files
vim.opt.ignorecase = true                                                     -- ignore case in search patterns
vim.opt.showmode = false                                                      -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0                                                       -- always show tabs
vim.opt.smartcase = true                                                      -- smart case
vim.opt.splitbelow = true                                                     -- force all horizontal splits to go below current window
vim.opt.undofile = true                                                       -- enable persistent undo
vim.opt.swapfile = false                                                      -- creates a swapfile
vim.opt.splitright = true                                                     -- force all vertical splits to go to the right of current window
vim.opt.timeoutlen = 1000                                                     -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.updatetime = 300                                                      -- faster completion (4000ms default)
vim.opt.expandtab = true                                                      -- convert tabs to spaces
vim.opt.cursorline = true                                                     -- highlight the current line
vim.opt.fillchars.eob=" "                                                     -- show empty lines at the end of a buffer as ` ` {default `~`}
vim.opt.signcolumn = "yes"                                                    -- always show the sign column, otherwise it would shift the text each time
vim.opt.writebackup = false                                                   -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.shortmess:append "c"                                                  -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
vim.opt.smartindent = true                                                    -- make indenting smarter again
vim.opt.termguicolors = true                                                  -- Enables 24-bit RGB color in the TUI. This is supported by most terminals.
vim.opt.iskeyword:append("-")                                                 -- treats words with `-` as single words
vim.opt.fileencoding = "utf-8"                                                -- the encoding written to a file
vim.opt.clipboard = "unnamedplus"                                             -- allows neovim to access the system clipboard
vim.g.lazygit_floating_window_use_plenary = true                              -- use plenary for floating windows
vim.cmd("colorscheme tokyonight-night")                                       -- set colorscheme

-- Keymaps

local oil = require('oil')
local telescope = require('telescope.builtin')

vim.keymap.set('n', ';', ':', {})                                             -- use ; to enter command mode
vim.keymap.set('n', '\'', ':!', {})                                           -- use ' to enter shell command mode
vim.keymap.set('n', '<leader>s', ':wa!<CR>', {})                              -- save all buffers
vim.keymap.set('n', '<leader>rc', ':luafile ~/.config/nvim/init.lua<CR>', {}) -- reload configuration
vim.keymap.set('n', 'ff', telescope.find_files, {})                           -- find files using telescope
vim.keymap.set('n', 'fg', telescope.live_grep, {})                            -- grep through files
vim.keymap.set('n', 'fb', telescope.buffers, {})                              -- list open buffers 
vim.keymap.set('n', '<leader>g', ':LazyGit<CR>', {})                          -- open lazygit
vim.keymap.set('n', '<leader>n', ':ObsidianSearch<CR>', {})                   -- open obsidian search
vim.keymap.set('n', '-', function()
  oil.open()
  vim.wait(1000, function()
    return oil.get_cursor_entry() ~= nil
  end)
  if oil.get_cursor_entry() then
    oil.open_preview()
  end
end)
