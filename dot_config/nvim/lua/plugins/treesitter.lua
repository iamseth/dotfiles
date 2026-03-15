return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		opts = function()
			local ensure_installed = {
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
				"svelte",
				"html",
				"css",
				"javascript",
				"typescript",
			}
			local filetypes = {
				"go",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"python",
				"sh",
				"json",
				"yaml",
				"dockerfile",
				"gowork",
				"gomod",
				"gosum",
				"sql",
				"gotmpl",
				"svelte",
				"html",
				"css",
				"javascript",
				"typescript",
			}

			return {
				install_dir = vim.fn.stdpath("data") .. "/site",
				ensure_installed = ensure_installed,
				highlight_filetypes = filetypes,
				indent_filetypes = filetypes,
			}
		end,
		config = function(_, opts)
			local treesitter = require("nvim-treesitter")
			treesitter.setup({ install_dir = opts.install_dir })

			vim.schedule(function()
				local installed = treesitter.get_installed()
				local missing = vim.tbl_filter(function(parser)
					return not vim.tbl_contains(installed, parser)
				end, opts.ensure_installed)

				if #missing > 0 then
					treesitter.install(missing)
				end
			end)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("seth-treesitter-highlight", { clear = true }),
				pattern = opts.highlight_filetypes,
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("seth-treesitter-indent", { clear = true }),
				pattern = opts.indent_filetypes,
				callback = function(args)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
