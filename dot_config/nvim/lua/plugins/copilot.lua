return {
	{
		"zbirenbaum/copilot.lua",
		opts = {
			filetypes = { ["*"] = true },
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = false,
				auto_trigger = false,
				keymap = {
					accept_word = false,
					accept_line = false,
					accept = "<S-Tab>",
				},
			},
		},
	},
}
