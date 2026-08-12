local seth_group = vim.api.nvim_create_augroup("seth-config", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeavePre", "FocusLost" }, {
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
			"<leader>am",
			"o<!-- AGENT:  --><Left><Left><Left><Left>",
			vim.tbl_extend("force", map_opts, { desc = "Add AGENT marker" })
		)

		vim.keymap.set("n", "<leader>al", function()
			local filename = vim.api.nvim_buf_get_name(args.buf)
			local directory = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()
			local root_result = vim.system({ "git", "-C", directory, "rev-parse", "--show-toplevel" }, { text = true })
				:wait()

			if root_result.code ~= 0 then
				vim.notify("Current buffer is not in a git repository", vim.log.levels.WARN)
				return
			end

			local root = vim.trim(root_result.stdout)
			local grep_result = vim.system(
				{ "git", "-C", root, "grep", "-n", "--column", "--no-color", "AGENT:" },
				{ text = true }
			):wait()
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
		end, vim.tbl_extend("force", map_opts, { desc = "List AGENT markers" }))
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = seth_group,
	pattern = "*.go",
	callback = function(args)
		local gopls = vim.lsp.get_clients({ bufnr = args.buf, name = "gopls" })[1]
		if not gopls then
			return
		end

		local params = vim.lsp.util.make_range_params(0, gopls.offset_encoding)
		params.context = { only = { "source.organizeImports" } }
		local response = gopls:request_sync("textDocument/codeAction", params, 1000, args.buf)
		for _, action in pairs((response or {}).result or {}) do
			if action.edit then
				vim.lsp.util.apply_workspace_edit(action.edit, gopls.offset_encoding)
			end
		end

		vim.lsp.buf.format({ async = false, bufnr = args.buf, name = "gopls" })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = seth_group,
	pattern = "*.svelte",
	callback = function(args)
		vim.lsp.buf.format({ async = false, bufnr = args.buf, name = "svelte" })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = seth_group,
	callback = function(args)
		local map_opts = { buffer = args.buf, silent = true }
		vim.keymap.set(
			"n",
			"gd",
			vim.lsp.buf.definition,
			vim.tbl_extend("force", map_opts, { desc = "LSP definition" })
		)
		vim.keymap.set(
			"n",
			"<leader>lr",
			vim.lsp.buf.rename,
			vim.tbl_extend("force", map_opts, { desc = "LSP rename" })
		)
		vim.keymap.set(
			"n",
			"<leader>la",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", map_opts, { desc = "LSP code action" })
		)
		vim.keymap.set(
			"n",
			"<leader>ld",
			vim.diagnostic.setloclist,
			vim.tbl_extend("force", map_opts, { desc = "Open diagnostic location list" })
		)
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
