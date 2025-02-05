require('plugins')
require('keymappings')
require('autocommands')
require('settings')



-- Automatically show hover documentation when the cursor stops moving
-- vim.api.nvim_create_autocmd("CursorHold", {
--   pattern = "*.go", -- Apply to Go files only; adjust as needed
--   callback = function()
--     local lsp_clients = vim.lsp.get_active_clients()
--     if lsp_clients and next(lsp_clients) ~= nil then
--       vim.lsp.buf.hover()
--     end
--   end,
-- })





vim.api.nvim_create_user_command('Upper',
  function(opts)
    print(string.upper(opts.fargs[1]))
  end,
  { nargs = 1 }
)





enabled = false
print("Seth loaded. Enabled: " .. tostring(enabled))
vim.api.nvim_create_user_command('Seth',

  
  function(opts)
    if enabled then
      return
    end

    enabled = true
    vim.keymap.set("n", "<Down>", "gj", {})
    vim.keymap.set("n", "<Up>", "gk", {})
    vim.opt.number = false
    vim.opt.cursorline = false
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "bg" })

    -- Left
    vim.cmd("leftabove vnew")
    vim.cmd("vertical resize 50")
    vim.opt_local.modifiable = false

    -- Right
    vim.cmd("wincmd l")
    vim.cmd("vnew")
    vim.cmd("vertical resize 50")
    vim.opt_local.modifiable = false

    -- Center
    vim.cmd("wincmd h")
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true

    -- Move cursor to bottom of buffer.
    vim.cmd("normal G")


    print("Seth enabled. Enabled: " .. tostring(enabled))

  end,
  { nargs = 0 }
)

