return {
	{
		"tomasky/bookmarks.nvim",
		lazy = true,
		opts = {
			save_file = vim.fn.expand("$HOME/.config/nvim/bookmarks"),
			on_attach = function(bufnr)
				local bm = require("bookmarks")
				local map = vim.keymap.set
				map("n", "mm", bm.bookmark_toggle)
				map("n", "mi", bm.bookmark_ann)
				map("n", "mc", bm.bookmark_clean)
				map("n", "mn", bm.bookmark_next)
				map("n", "mp", bm.bookmark_prev)
				map("n", "ml", bm.bookmark_list)
				map("n", "mx", bm.bookmark_clear_all)
			end,
		},
	},
}
