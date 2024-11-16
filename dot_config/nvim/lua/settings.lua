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
vim.cmd("highlight WinSeparator guifg=#FF8800")
