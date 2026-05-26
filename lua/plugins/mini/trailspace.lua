-- mini.trailspace: show / remove trailing whitespace
require('mini.trailspace').setup()

local augroup = vim.api.nvim_create_augroup('mini.trailspace', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  callback = function()
    vim.api.nvim_set_hl(0, 'MiniTrailspace', { bg = '#660000', fg = 'NONE' }) -- dark red
  end,
})

vim.keymap.set('n', '<leader>TT', function()
  require('mini.trailspace').trim()
end, { silent = true, desc = 'Trim trailing whitespace' })
