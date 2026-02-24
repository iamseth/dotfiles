return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},

		config = function()
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
				pickers = {
					find_files = { theme = "ivy" },
					live_grep = { theme = "ivy" },
					buffers = { theme = "ivy" },
					lsp_document_symbols = { theme = "dropdown" },
				},
				defaults = {
					mappings = {
						i = {
              -- Close on <esc> in insert mode
							["<esc>"] = actions.close,
						},

						n = {
              -- Close on <esc> in normal mode
							["<esc>"] = actions.close,
						},

					},
				},
			})
		end,
	},
}
