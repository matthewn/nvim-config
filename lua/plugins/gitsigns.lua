require('gitsigns').setup({
  signcolumn = false,          -- do not show signcolumn on attach

  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', '<leader>gs', gitsigns.toggle_signs)
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)
    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end)
  end
})

local lime = '#00FF00'
vim.api.nvim_set_hl(0, 'GitSignsStagedAdd',    { fg = lime })
vim.api.nvim_set_hl(0, 'GitSignsStagedChange', { fg = lime })
vim.api.nvim_set_hl(0, 'GitSignsStagedDelete', { fg = lime })
vim.api.nvim_set_hl(0, 'GitSignsStagedAddNr',     { fg = lime })
vim.api.nvim_set_hl(0, 'GitSignsStagedAddLn',     { fg = lime })
vim.api.nvim_set_hl(0, 'GitSignsStagedChangeNr',  { fg = lime })
vim.api.nvim_set_hl(0, 'GitSignsStagedChangeLn',  { fg = lime })
vim.api.nvim_set_hl(0, 'GitSignsStagedDeleteNr',  { fg = lime })
vim.api.nvim_set_hl(0, 'GitSignsStagedDeleteLn',  { fg = lime })
