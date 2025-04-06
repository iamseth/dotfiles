-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
    { "tpope/vim-commentary" },
		{ "kdheepak/lazygit.nvim" },
		{ "airblade/vim-gitgutter" },
		{ "nvim-tree/nvim-web-devicons" },
		{ "nvim-lua/popup.nvim" },
		{ "MunifTanjim/nui.nvim" },
		{ "nvim-lua/plenary.nvim" },
		{ "ray-x/guihua.lua" },
		{ "MeanderingProgrammer/render-markdown.nvim" },
		{ "junegunn/goyo.vim" },
		{ "junegunn/limelight.vim" },
		{ "preservim/vim-pencil",
			config = function()
				vim.g["pencil#wrapModeDefault"] = "soft"
				vim.g["pencil#textwidthDefault"] = 80
				vim.g["pencil#autoformat"] = 1
				vim.g["pencil#autoformat#textwidth"] = 80
			end,
		},
		{ "tomasky/bookmarks.nvim",
			config = function()
				require("bookmarks").setup({
					save_file = vim.fn.expand("$HOME/.config/nvim/bookmarks"),
					on_attach = function(bufnr)
						local bm = require("bookmarks")
						local map = vim.keymap.set
						map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
						map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
						map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
						map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
						map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
						map("n", "ml", bm.bookmark_list) -- show marked file list in quickfix window
						map("n", "mx", bm.bookmark_clear_all) -- removes all bookmarks
					end,
				})
			end,
		},
		{	"zbirenbaum/copilot.lua",
			opts = { filetypes = { ["*"] = true } },
			config = function()
				require("copilot").setup({
					suggestion = {
						auto_trigger = true,
						keymap = {
							accept_word = false,
							accept_line = false,
							accept = "<S-Tab>",
						},
					},
				})
			end,
		},
		{	"projekt0n/github-nvim-theme",
			config = function()
				vim.cmd("colorscheme github_dark_default")
			end,
		},
		{	"ray-x/go.nvim",
			ft = { "go", "gomod" },
			event = { "CmdlineEnter" },
			build = ':lua require("go.install").update_all_sync()',
			config = function()
				require("go").setup({
					run_in_floaterm = { enable = true },
				})
			end,
		},
		{ "stevearc/oil.nvim",
			config = function()
				require("oil").setup({
					default_file_explorer = true,
					preview = {
						update_on_cursor_moved = true,
					},
					columns = {
						"icon",
						"size",
						"mtime",
						"permissions",
					},
					view_options = {
						show_hidden = true,
					},
				})
			end,
		},
		{ "nvim-lualine/lualine.nvim",
			config = function()
				require("lualine").setup({
					options = {
						theme = "github_dark_default",
						globalstatus = true,
						icons_enabled = true,
					},
				})
			end,
		},
		{ "nvim-telescope/telescope.nvim",
			config = function()
				local actions = require("telescope.actions")
				require("telescope").setup({
					pickers = {
						find_files = { theme = "ivy" },
						live_grep = { theme = "ivy" },
						buffers = { theme = "ivy" },
						lsp_document_symbols = { theme = "dropdown" },
					},
					defaults = {
						mappings = {
							i = { ["<esc>"] = actions.close },
							n = { ["<esc>"] = actions.close },
							-- map ctrl+v to open in vertical split
							i = { ["<C-v>"] = actions.select_vertical },
						},
					},
				})
			end,
		},
		{ "folke/noice.nvim",
			config = function()
				require("noice").setup({
					presets = {
						bottom_search = true, -- use a classic bottom cmdline for search
						command_palette = false,
						long_message_to_split = true, -- long messages will be sent to a split
						inc_rename = false, -- enables an input dialog for inc-rename.nvim
						lsp_doc_border = false, -- add a border to hover docs and signature help
					},
					routes = {
						{ filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
					},
				})
			end,
		},
		{ "rcarriga/nvim-notify",
			config = function()
				vim.notify = require("notify")
				require("notify").setup({
					stages = "static",
					timeout = 3000,
				})
			end,
		},
		{ "neovim/nvim-lspconfig",
			config = function()
				require("lspconfig").gopls.setup({
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
								shadow = true,
							},
							staticcheck = true,
							gofumpt = true,
							vulncheck = true,
						},
					},
				})
				require("lspconfig").solargraph.setup({
					cmd = { "solargraph", "stdio" },
					filetypes = { "ruby" },
					root_dir = require("lspconfig.util").root_pattern("Gemfile", ".git"),
					settings = {
						solargraph = {
							diagnostics = true,
							completion = true,
							formatting = true,
						},
					},
				})
			end,
		},
		{ "nvim-treesitter/nvim-treesitter",
			config = function()
				require("nvim-treesitter.configs").setup({
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
					sync_install = true,
					auto_install = true,
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
				})
			end,
		},
    { "nvim-treesitter/nvim-treesitter-textobjects",
      config = function()
        require("nvim-treesitter.configs").setup({
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["as"] = "@scope",
                ["a/"] = "@comment.outer",
              },
            },
          },
        })
      end,
    },

		{ "yetone/avante.nvim",
			event = "VeryLazy",
			version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
			opts = {
				provider = "openai",
				openai = {
					endpoint = "https://api.openai.com/v1",
					model = "gpt-4o",
					timeout = 30000,
					temperature = 0,
					max_tokens = 4096,
				},
			},
			build = "make BUILD_FROM_SOURCE=true",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"stevearc/dressing.nvim",
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
				"echasnovski/mini.pick",
				"nvim-telescope/telescope.nvim",
				"hrsh7th/nvim-cmp",
				"ibhagwan/fzf-lua",
				"nvim-tree/nvim-web-devicons",
				"zbirenbaum/copilot.lua",
				{ "MeanderingProgrammer/render-markdown.nvim",
					opts = { file_types = { "markdown", "Avante" }, },
					ft = { "markdown", "Avante" },
				},
			},
		},
	},
})
