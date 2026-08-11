local seth_group = vim.api.nvim_create_augroup("seth-config", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeavePre", "TextChanged", "TextChangedP" }, {
	group = seth_group,
	pattern = "*.md",
	callback = function(args)
		if
			vim.bo[args.buf].modified
			and not vim.bo[args.buf].readonly
			and vim.api.nvim_buf_get_name(args.buf) ~= ""
		then
			vim.api.nvim_buf_call(args.buf, function()
				vim.cmd("silent write")
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = seth_group,
	pattern = "markdown",
	callback = function(args)
		local map_opts = { buffer = args.buf, silent = true }

		vim.keymap.set(
			"n",
			"<leader>ac",
			"o<!-- AGENT:  --><Left><Left><Left><Left>",
			vim.tbl_extend("force", map_opts, { desc = "Add AGENT comment" })
		)

		vim.keymap.set("n", "<leader>aa", function()
			local filename = vim.api.nvim_buf_get_name(args.buf)
			local directory = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()
			local root_result =
				vim.system({ "git", "-C", directory, "rev-parse", "--show-toplevel" }, { text = true }):wait()

			if root_result.code ~= 0 then
				vim.notify("Current buffer is not in a git repository", vim.log.levels.WARN)
				return
			end

			local root = vim.trim(root_result.stdout)
			local grep_result =
				vim.system({ "git", "-C", root, "grep", "-n", "--column", "--no-color", "AGENT:" }, { text = true })
					:wait()
			local items = {}

			for line in grep_result.stdout:gmatch("[^\r\n]+") do
				local path, lnum, col, text = line:match("^(.-):(%d+):(%d+):(.*)$")
				if path then
					items[#items + 1] = {
						filename = root .. "/" .. path,
						lnum = tonumber(lnum),
						col = tonumber(col),
						text = text,
					}
				end
			end

			vim.fn.setqflist({}, "r", {
				title = "AGENT markers: " .. root,
				items = items,
			})
			vim.cmd("copen")
		end, vim.tbl_extend("force", map_opts, { desc = "List AGENT comments" }))
	end,
})

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

vim.api.nvim_create_autocmd("BufWritePre", {
	group = seth_group,
	pattern = "*.svelte",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = seth_group,
	callback = function(args)
		local map_opts = { buffer = args.buf, silent = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", map_opts, { desc = "LSP definition" }))
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", map_opts, { desc = "LSP rename" }))
		vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, vim.tbl_extend("force", map_opts, { desc = "LSP code action" }))
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
