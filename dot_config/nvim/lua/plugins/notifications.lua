return {
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			vim.notify = require("notify")
			require("notify").setup({
				stages = "static",
				timeout = 3000,
			})
		end,
	},
}
