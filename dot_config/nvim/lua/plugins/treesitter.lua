return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"go",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"regex",
				"python",
				"bash",
				"json",
				"yaml",
				"dockerfile",
				"gowork",
				"gomod",
				"gosum",
				"sql",
				"gotmpl",
				"comment",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true, disable = { "ruby" } },
		},
	},
}
