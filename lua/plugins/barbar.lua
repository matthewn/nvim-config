vim.g.barbar_auto_setup = false -- req'd to make setup() work

require('barbar').setup {
  -- show filetype icons if gui; no close buttons ever
  icons = { button = false, filetype = { enabled = vim.g.neovide and true or false } },
}

-- barbar/startify integration (ensure barbar buffer order is saved)
vim.g.startify_session_before_save = {
  'doautocmd User SessionSavePre',
}

-- set up barbar-aware buffer next/previous keymaps
if vim.g.neovide then
  vim.keymap.set({ 'n', 'i' }, '<c-tab>', '<cmd>BufferNext<cr>', { silent = true })
  vim.keymap.set({ 'n', 'i' }, '<c-s-tab>', '<cmd>BufferPrevious<cr>', { silent = true })
end
vim.keymap.set('n', ']b', '<cmd>BufferNext<cr>', { silent = true })
vim.keymap.set('n', '[b', '<cmd>BufferPrevious<cr>', { silent = true })
vim.keymap.set('n', ']B', '<cmd>BufferLast<cr>', { silent = true })
vim.keymap.set('n', '[B', '<cmd>BufferGoto 1<cr>', { silent = true })
vim.keymap.set('n', 'gb', '<cmd>BufferPick<cr>', { silent = true })
