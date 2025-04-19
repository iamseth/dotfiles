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
		{ "preservim/vim-pencil",
		{ "tpope/vim-commentary" },
		{ "kdheepak/lazygit.nvim" },
		{ "junegunn/limelight.vim" },
		{ "airblade/vim-gitgutter" },
		{	"nvim-telescope/telescope.nvim",
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
							i = { ["<C-v>"] = actions.select_vertical },
						},
					},
				})
			end,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
      },
		},
		{ "MeanderingProgrammer/render-markdown.nvim" },
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
						map("n", "mm", bm.bookmark_toggle)
						map("n", "mi", bm.bookmark_ann)
						map("n", "mc", bm.bookmark_clean)
						map("n", "mn", bm.bookmark_next)
						map("n", "mp", bm.bookmark_prev)
						map("n", "ml", bm.bookmark_list)
						map("n", "mx", bm.bookmark_clear_all)
					end,
				})
			end,
		},
    { "projekt0n/github-nvim-theme",
      config = function()
        vim.cmd("colorscheme github_dark_default")
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
      dependencies = {
        "MunifTanjim/nui.nvim",
		 "nvim-lua/popup.nvim" ,
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
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
    {
			"neovim/nvim-lspconfig",
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
						},
					},
				})
			end,
		},
		{ "ray-x/go.nvim",
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






  },
})

