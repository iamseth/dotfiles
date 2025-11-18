vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client.name == "gopls" then
      vim.keymap.set("n", "<leader>r", ":lua vim.lsp.buf.rename()<CR>", { buffer = args.buf })
      vim.keymap.set("n", "<leader>a", ":lua vim.lsp.buf.code_action()<CR>", { buffer = args.buf })
    end

    -- if client:supports_method('textDocument/completion') then
    --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true } )
    -- end

  end
})
