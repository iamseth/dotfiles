local opts = { noremap = true, silent = true }

vim.keymap.set("n", "qq", ":SmartQuit<CR>", opts) -- smart quit current context
vim.keymap.set("t", "qq", "<C-\\><C-N><cmd>SmartQuit<CR>", opts) -- smart quit terminal context
vim.keymap.set("n", "-", ":Oil<CR>", opts) -- open oil
vim.keymap.set("n", "J", "<C-w>j", opts) -- move to window below
vim.keymap.set("n", "K", "<C-w>k", opts) -- move to window above
vim.keymap.set("n", "H", "<C-w>h", opts) -- move to window left
vim.keymap.set("n", "L", "<C-w>l", opts) -- move to window right
vim.keymap.set("n", "ss", function()
	require("telescope.builtin").grep_string()
end, opts) -- search in current directory
vim.keymap.set("n", "sl", function()
	require("telescope.builtin").buffers()
end, opts) -- list open buffers
vim.keymap.set("n", "ff", function()
	require("telescope.builtin").find_files()
end, opts) -- find files using telescope
vim.keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts) -- go to definition
vim.keymap.set("n", "<leader>v", ":vsplit<CR>", opts) -- vertical split
vim.keymap.set("n", "<leader>h", ":split<CR>", opts) -- horizontal split
vim.keymap.set("n", "<leader>w", ":SaveAll<CR>", opts) -- save all buffers
vim.keymap.set("n", "<leader>g", ":LazyGit<CR>", opts) -- open lazygit
vim.keymap.set("n", "<leader>t", ":Floaterminal<CR>", opts) -- open terminal
vim.keymap.set("n", "<leader>cc", ":Copilot toggle<CR>", opts) -- toggle copilot
vim.keymap.set("n", "<C-j>", "<C-d>zz", opts) -- scroll half a page down/up and center the cursor
vim.keymap.set("n", "<C-k>", "<C-u>zz", opts) -- scroll half a page down/up and center the cursor
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- clear search highlights
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
