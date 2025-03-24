-- settings
vim.opt.tabstop = 2                                                           -- number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2                                                        -- number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true                                                      -- convert tabs to spaces
vim.opt.scrolloff = 8                                                         -- minimal number of screen lines to keep above and below the cursor
vim.opt.number = true                                                         -- set numbered lines
vim.opt.relativenumber = true                                                 -- set relative numbered lines
vim.opt.pumheight = 10                                                        -- pop up menu heigt
vim.opt.mouse = "anicr"                                                       -- allow the mouse to be used in neovim
vim.opt.showmode = false                                                      -- we don't need to see things like -- INSERT -- anymore
vim.opt.ignorecase = true                                                     -- ignore case in search patterns
vim.opt.smartcase = true                                                      -- smart case
vim.opt.splitright = true                                                     -- force all vertical splits to go to the right of current window
vim.opt.splitbelow = true                                                     -- force all horizontal splits to go below current window
vim.opt.termguicolors = true                                                  -- Enables 24-bit RGB color in the TUI. This is supported by most terminals.
vim.opt.iskeyword:append('-', '_', '@')                                       -- treat dash, underscore and @ as part of a word
vim.opt.clipboard = "unnamedplus"                                             -- allows neovim to access the system clipboard
vim.opt.wrap = false                                                          -- display lines as one long line 
vim.g.mapleader = ' '                                                         -- set the leader key to space
vim.cmd("highlight WinSeparator guifg=#A678D3")                               -- set the color of the window separator


-- plugins
require('plugins')
local telescope = require('telescope.builtin')

-- keymaps
vim.keymap.set('n', ';', ':', {})                                             -- use ; to enter command mode
vim.keymap.set('n', '<leader>s', ':wa!<CR>', {})                              -- save all buffers
vim.keymap.set('n', '<leader>rc', ':luafile ~/.config/nvim/init.lua<CR>', {}) -- reload configuration
vim.keymap.set('n', 'fg', telescope.live_grep, {})                            -- grep through files
vim.keymap.set('n', 'fb', telescope.buffers, {})                              -- list open buffers 
vim.keymap.set('n', 'ff', telescope.find_files, {})                           -- find files using telescope
vim.keymap.set('n', 'fs', telescope.lsp_document_symbols, {})                 -- find symbols in current buffer
vim.keymap.set('n', '<leader>g', ":LazyGit<CR>", {})                          -- open lazygit
vim.keymap.set('n', '<esc>', '<nop>', {})                                     -- Map escape when in normal mode to do nothing.
vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', {})            -- go to definition
vim.keymap.set('n', '-', ':Oil<CR>', {})                                      -- open oil
vim.keymap.set('n', 'J', '<C-w>j', { noremap = true, silent = true })         -- move to window below
vim.keymap.set('n', 'K', '<C-w>k', { noremap = true, silent = true })         -- move to window above
vim.keymap.set('n', 'H', '<C-w>h', { noremap = true, silent = true })         -- move to window left
vim.keymap.set('n', 'L', '<C-w>l', { noremap = true, silent = true })         -- move to window right

-- autocommands
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

local zen_enabled = false
vim.api.nvim_create_user_command('ZenToggle', function()
  local lualine = require('lualine').hide()
  if zen_enabled then
    zen_enabled = false
    vim.cmd('Goyo!')
    vim.cmd('Limelight!')
    vim.cmd('PencilToggle')
  else
    zen_enabled = true
    vim.cmd('Goyo')
    vim.cmd('Limelight')
    vim.cmd('PencilToggle')
  end
end, {})
