local oil = require('oil')
local telescope = require('telescope.builtin')

vim.keymap.set('n', ';', ':', {})                                             -- use ; to enter command mode
vim.keymap.set('n', '<leader>s', ':wa!<CR>', {})                              -- save all buffers
vim.keymap.set('n', '<leader>rc', ':luafile ~/.config/nvim/init.lua<CR>', {}) -- reload configuration
vim.keymap.set('n', '<leader>q', ':q<CR>', {})                                -- quit
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', {})                              -- quit all

vim.keymap.set('n', 'fg', telescope.live_grep, {})                            -- grep through files
vim.keymap.set('n', 'fb', telescope.buffers, {})                              -- list open buffers 
vim.keymap.set('n', 'ff', telescope.find_files, {})                           -- find files using telescope

vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>', {})                       -- open toggleterm
vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', {})            -- go to definition
vim.keymap.set('n', '-', function()
  oil.open()
  vim.wait(1000, function()
    return oil.get_cursor_entry() ~= nil
  end)
  if oil.get_cursor_entry() then
    oil.open_preview()
  end
end)