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
    
-- 		{
-- 			"nvim-treesitter/nvim-treesitter-textobjects",
-- 			config = function()
-- 				require("nvim-treesitter.configs").setup({
-- 					textobjects = {
-- 						select = {
-- 							enable = true,
-- 							lookahead = true,
-- 							keymaps = {
-- 								["af"] = "@function.outer",
-- 								["if"] = "@function.inner",
-- 								["ac"] = "@class.outer",
-- 								["ic"] = "@class.inner",
-- 								["as"] = "@scope",
-- 								["a/"] = "@comment.outer",
-- 							},
-- 						},
-- 					},
-- 				})
-- 			end,
-- 		},

	},
}
