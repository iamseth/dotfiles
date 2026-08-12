return {
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function(_, opts)
			require("copilot").setup(opts)
		end,
		opts = {
			filetypes = {
				go = true,
				python = true,
				sh = true,
				["*"] = false,
			},
			panel = {
				enabled = true,
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept_word = false,
					accept_line = false,
					accept = "<M-l>",
					dismiss = "<C-]>",
				},
			},
		},
	},
}
