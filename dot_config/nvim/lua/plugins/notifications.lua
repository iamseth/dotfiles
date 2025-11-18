return {
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
			require("notify").setup({
				stages = "static",
				timeout = 3000,
			})
		end,
	},
}
