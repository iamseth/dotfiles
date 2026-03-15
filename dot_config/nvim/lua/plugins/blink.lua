return {
	{
		"saghen/blink.cmp",
		version = "*",
		lazy = false,
		opts = {
			keymap = {
				preset = "default",
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
