return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lsps = {
				{
					"gopls",
					{
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
					},
				},
				{ "sqlls" },
				{ "lua_ls" },
				{ "pyright" },
				{ "bashls" },
				{ "yamlls" },
				{ "dockerls" },
				{ "marksman" },
			}
			for _, lsp in ipairs(lsps) do
				local name, config = lsp[1], lsp[2]
				vim.lsp.enable(name)
				if config then
					vim.lsp.config(name, config)
				end
			end
		end,
	},
}
