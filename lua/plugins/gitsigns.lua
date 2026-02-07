require('gitsigns').setup({
  signcolumn = false, -- do not show signcolumn on attach

  on_attach = function(bufnr)
  local gitsigns = require('gitsigns')

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  map('n', '<leader>s', gitsigns.toggle_signs, { desc = 'Toggle git signs' })
  map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
  map('v', '<leader>hs', function()
    gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  end, { desc = 'Stage hunk (visual)' })
  map('n', '<leader>hb', function()
    gitsigns.blame_line({ full = true })
  end, { desc = 'Show git blame' })
end
})
