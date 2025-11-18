return {
	{
		"ray-x/go.nvim",
		ft = { "go", "gomod" },
		event = { "CmdlineEnter" },
		build = ':lua require("go.install").update_all_sync()',
		config = function()
			require("go").setup({
				run_in_floaterm = { enable = true },
			})
		end,
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
