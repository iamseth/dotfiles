local function copilot_component()
	local client = package.loaded["copilot.client"]
	if not client then
		return "COP:..."
	end

	if client.is_disabled() then
		return "COP:off"
	end

	if not client.buf_is_attached(0) then
		return "COP:..."
	end

	local status = package.loaded["copilot.status"]
	if not status then
		return "COP:on"
	end

	if status.data.status == "InProgress" then
		return "COP:wrk"
	end

	if status.data.status == "Warning" then
		return "COP:warn"
	end

	return "COP:on"
end

local function copilot_color()
	local client = package.loaded["copilot.client"]
	if not client then
		return { fg = "#d29922" }
	end

	if client.is_disabled() then
		return { fg = "#e5534b" }
	end

	if not client.buf_is_attached(0) then
		return { fg = "#d29922" }
	end

	local status = package.loaded["copilot.status"]
	if status and status.data.status == "Warning" then
		return { fg = "#d29922" }
	end

	return { fg = "#57ab5a" }
end

local function refresh_lualine()
	local ok, lualine = pcall(require, "lualine")
	if ok then
		lualine.refresh()
	end
end

return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				theme = "github_dark_default",
				globalstatus = true,
				icons_enabled = true,
			},
			sections = {
				lualine_x = {
					{
						copilot_component,
						color = copilot_color,
					},
					"encoding",
					"fileformat",
					"filetype",
				},
			},
		},
		config = function(_, opts)
			require("lualine").setup(opts)

			vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter", "InsertLeave", "CursorHold", "CmdlineLeave" }, {
				group = vim.api.nvim_create_augroup("copilot-lualine-refresh", { clear = true }),
				callback = refresh_lualine,
			})
		end,
	},
}
