require('treesj').setup({
  use_default_keymaps = false,
})

vim.keymap.set(
  'n',
  '<leader>j',
  require('treesj').toggle,
  { desc = 'TreeSJ toggle' }
)
