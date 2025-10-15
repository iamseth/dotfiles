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
vim.opt.iskeyword:append("-", "_", "@") -- treat dash, underscore and @ as part of a word
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.wrap = false -- display lines as one long line
vim.g.mapleader = " " -- set the leader key to space

require("plugins")

vim.cmd("highlight WinSeparator guifg=#A678D3") -- set the color of the window separator
local telescope = require("telescope.builtin")
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "qq", ":q<CR>", opts) -- quit
vim.keymap.set("n", "-", ":Oil<CR>", opts) -- open oil
vim.keymap.set("n", "J", "<C-w>j", opts) -- move to window below
vim.keymap.set("n", "K", "<C-w>k", opts) -- move to window above
vim.keymap.set("n", "H", "<C-w>h", opts) -- move to window left
vim.keymap.set("n", "L", "<C-w>l", opts) -- move to window right
vim.keymap.set("n", "ss", telescope.live_grep, opts) -- search in current directory
vim.keymap.set("n", "sl", telescope.buffers, opts) -- list open buffers
vim.keymap.set("n", "ff", telescope.find_files, opts) -- find files using telescope
vim.keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts) -- go to definition
vim.keymap.set("n", "<leader>v", ":vsplit<CR>", opts) -- vertical split
vim.keymap.set("n", "<leader>h", ":split<CR>", opts) -- horizontal split
vim.keymap.set("n", "<leader>r", ":ReloadConfig<CR>", opts) -- reload configuration
vim.keymap.set("n", "<leader>w", ":SaveAll<CR>", opts) -- save all buffers
vim.keymap.set("n", "<leader>g", ":LazyGit<CR>", opts) -- open lazygit
vim.keymap.set("n", "<leader>t", ":Floaterminal<CR>", opts) -- open terminal
vim.keymap.set("t", "qq", "<C-\\><C-N>:q<CR>", opts) -- quit terminal
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts) -- center screen when scrolling down
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts) -- center screen when scrolling up

vim.api.nvim_create_user_command("SaveAll", function()
	vim.cmd("wa!")
	vim.notify("All buffers saved.", vim.log.levels.INFO, { title = "Buffers Written" })
end, {})

vim.api.nvim_create_user_command("ReloadConfig", function()
	vim.cmd("source ~/.config/nvim/init.lua")
	vim.notify("Configuration reloaded.", vim.log.levels.INFO, { title = "Config Reloaded" })
end, {})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

local state = {
	floating = {
		buf = -1,
		win = -1,
	},
	zen_mode = false,
}

vim.api.nvim_create_user_command("ZenToggle", function()
	local lualine = require("lualine").hide()
	if state.zen_mode then
		vim.cmd("Goyo!")
		vim.cmd("Limelight!")
		vim.cmd("PencilToggle")
		state.zen_mode = false
	else
		vim.cmd("Goyo")
		vim.cmd("Limelight")
		vim.cmd("PencilToggle")
		state.zen_mode = true
	end
end, {})

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
		vim.cmd.startinsert()
	else
		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

vim.api.nvim_create_user_command("Floaterminal", function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = create_floating_window({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
			vim.cmd.startinsert()
		end
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end, {})


vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client.name == "gopls" then
      vim.keymap.set("n", "<leader>r", ":lua vim.lsp.buf.rename()<CR>", { buffer = args.buf })
      vim.keymap.set("n", "<leader>a", ":lua vim.lsp.buf.code_action()<CR>", { buffer = args.buf })
    end

    -- if client:supports_method('textDocument/completion') then
    --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true } )
    -- end

  end
})
