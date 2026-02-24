vim.api.nvim_create_user_command("SaveAll", function()
	vim.cmd("wa!")
	vim.notify("All buffers saved.", vim.log.levels.INFO, { title = "Buffers Written" })
end, {})

local function write_current_buffer_if_needed(buf)
	if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].modified then
		return true
	end

	local buftype = vim.bo[buf].buftype
	if buftype ~= "" and buftype ~= "acwrite" then
		return true
	end

	local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
		vim.cmd("silent write")
	end)

	if not ok then
		vim.notify("Could not save buffer: " .. err, vim.log.levels.ERROR, { title = "Smart Quit" })
	end

	return ok
end

vim.api.nvim_create_user_command("SmartQuit", function()
	local buf = vim.api.nvim_get_current_buf()
	if not write_current_buffer_if_needed(buf) then
		return
	end

	local current_tab = vim.api.nvim_get_current_tabpage()
	local wins_in_tab = #vim.api.nvim_tabpage_list_wins(current_tab)
	local total_tabs = #vim.api.nvim_list_tabpages()

	if wins_in_tab > 1 then
		vim.cmd("close")
	elseif total_tabs > 1 then
		vim.cmd("tabclose")
	else
		vim.cmd("bdelete")
	end
end, {})

local state = {
	floating = {
		buf = -1,
		win = -1,
	},
	zen_mode = false,
}

vim.api.nvim_create_user_command("ZenToggle", function()
	local has_lualine, lualine = pcall(require, "lualine")
	if state.zen_mode then
		vim.cmd("Goyo!")
		vim.cmd("Limelight!")
		vim.cmd("PencilToggle")
		if has_lualine and lualine.hide then
			lualine.hide({ unhide = true })
		end
		state.zen_mode = false
	else
		vim.cmd("Goyo")
		vim.cmd("Limelight")
		vim.cmd("PencilToggle")
		if has_lualine and lualine.hide then
			lualine.hide()
		end
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
		end
		vim.cmd.startinsert()
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end, {})
