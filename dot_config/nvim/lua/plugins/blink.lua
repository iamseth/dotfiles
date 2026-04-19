return {
	{
		"saghen/blink.cmp",
		version = "*",
		lazy = false,
		opts = {
			keymap = {
				preset = "enter",
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
			},
			completion = {
				documentation = {
					auto_show = true,
				},
				ghost_text = {
					enabled = false,
				},
			},
		},
		config = function(_, opts)
			require("blink.cmp").setup(opts)
		end,
	},
}
