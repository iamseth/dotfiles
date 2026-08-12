local function apply_custom_highlights()
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#A678D3" })
end

local colors_group = vim.api.nvim_create_augroup("seth-colors", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = colors_group,
	callback = apply_custom_highlights,
})

apply_custom_highlights()
