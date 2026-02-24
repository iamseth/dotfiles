return {
	{
		"tomasky/bookmarks.nvim",
		event = "BufReadPost",
		opts = {
			save_file = vim.fn.expand("$HOME/.config/nvim/bookmarks"),
			on_attach = function(bufnr)
				local bm = require("bookmarks")
				local map = vim.keymap.set
				local map_opts = { buffer = bufnr, silent = true }
				map("n", "mm", bm.bookmark_toggle, map_opts)
				map("n", "mi", bm.bookmark_ann, map_opts)
				map("n", "mc", bm.bookmark_clean, map_opts)
				map("n", "mn", bm.bookmark_next, map_opts)
				map("n", "mp", bm.bookmark_prev, map_opts)
				map("n", "ml", bm.bookmark_list, map_opts)
				map("n", "mx", bm.bookmark_clear_all, map_opts)
			end,
		},
	},
}
