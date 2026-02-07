require('aerial').setup({
  nav = {
    -- show a preview of the code in the right column, when there are no child symbols
    preview = true,
    -- Keymaps in the nav window
    keymaps = {
      ['<cr>'] = 'actions.jump',
      ['<2-LeftMouse>'] = 'actions.jump',
      ['<c-v>'] = 'actions.jump_vsplit',
      ['<c-s>'] = 'actions.jump_split',
      ['h'] = 'actions.left',
      ['l'] = 'actions.right',
      ['q'] = 'actions.close',
    },
  },
})

vim.keymap.set('n', '<leader>t', ':AerialNavToggle<cr>', { silent = true, desc = 'Toggle code outline' })
