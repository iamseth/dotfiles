local telescope = require("telescope.builtin")
local opts = { noremap = true, silent = true }

-- vim.keymap.set("n", "qq", ":BufferClose!<CR>", opts) -- close buffer
vim.keymap.set("n", "qq", ":wq<CR>", opts) -- quit
vim.keymap.set("t", "qq", "<C-\\><C-N>:q<CR>", opts) -- quit terminal
vim.keymap.set("n", "-", ":Oil<CR>", opts) -- open oil
vim.keymap.set("n", "J", "<C-w>j", opts) -- move to window below
vim.keymap.set("n", "K", "<C-w>k", opts) -- move to window above
vim.keymap.set("n", "H", "<C-w>h", opts) -- move to window left
vim.keymap.set("n", "L", "<C-w>l", opts) -- move to window right
vim.keymap.set("n", "ss", telescope.grep_string, opts) -- search in current directory
vim.keymap.set("n", "sl", telescope.buffers, opts) -- list open buffers
vim.keymap.set("n", "ff", telescope.fd, opts) -- find files using telescope
vim.keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts) -- go to definition
vim.keymap.set("n", "<leader>v", ":vsplit<CR>", opts) -- vertical split
vim.keymap.set("n", "<leader>h", ":split<CR>", opts) -- horizontal split
vim.keymap.set("n", "<leader>r", ":ReloadConfig<CR>", opts) -- reload configuration
vim.keymap.set("n", "<leader>w", ":SaveAll<CR>", opts) -- save all buffers
vim.keymap.set("n", "<leader>g", ":LazyGit<CR>", opts) -- open lazygit
vim.keymap.set("n", "<leader>t", ":Floaterminal<CR>", opts) -- open terminal
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts) -- center screen when scrolling down
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts) -- center screen when scrolling up

vim.keymap.set("n", "<C-j>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-k>", "<C-u>zz", opts)

-- keymap for nt to add a new task in markdown
vim.keymap.set("n", "nt", "o- [ ] ", opts)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
