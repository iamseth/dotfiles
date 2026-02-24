local seth_group = vim.api.nvim_create_augroup("seth-config", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = seth_group,
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_clients({ id = cid })[1] or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format({ async = false })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = seth_group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "gopls" then
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = args.buf })
			vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { buffer = args.buf })
		end
	end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
