return {
	{ "junegunn/goyo.vim" },
	{ "preservim/vim-pencil" },
	{ "junegunn/limelight.vim" },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "RenderMarkdown",
		ft = { "markdown" },
		keys = {
			{ "<leader>mp", "<cmd>RenderMarkdown preview<CR>", desc = "Markdown preview split" },
		},
		opts = {
			render_modes = {},
		},
	},
}
