return {
	{
		"zbirenbaum/copilot.lua",
		config = function(_, opts)
			require("copilot").setup(opts)
			vim.cmd("Copilot disable")
		end,
		opts = {
			filetypes = { ["*"] = true },
			panel = {
				enabled = true,
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept_word = false,
					accept_line = false,
          accept = "<S-Tab>",
					dismiss = "<C-]>",
				},
			},
		},
	},
}
