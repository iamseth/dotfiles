vim.opt.tabstop = 2 -- number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2 -- number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.pumheight = 10 -- pop up menu heigt
vim.opt.mouse = "anicr" -- allow the mouse to be used in neovim
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.smartcase = true -- smart case
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.termguicolors = true -- Enables 24-bit RGB color in the TUI. This is supported by most terminals.
vim.opt.iskeyword:append({ "-", "_", "@" }) -- treat dash, underscore and @ as part of a word
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.wrap = false -- display lines as one long line
vim.opt.undofile = true -- Enable persistent undo
vim.opt.updatetime = 250 -- faster completion
vim.opt.timeoutlen = 300 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.g.mapleader = " " -- set the leader key to space
vim.g.maplocalleader = " " -- set the local leader key to space

-- Disable optional language providers we do not use.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.filetype.add({
	filename = {
		["go.work"] = "gowork",
	},
	extension = {
		gotmpl = "gotmpl",
	},
})
