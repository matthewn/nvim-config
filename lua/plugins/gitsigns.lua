require('gitsigns').setup({
  signcolumn = true, -- hide signs initially
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end)
    map('n', '<leader>hd', gitsigns.diffthis)
    map('n', '<leader>hD', function()
      gitsigns.diffthis('~')
    end)

    -- toggles
    map('n', '<leader>tg', gitsigns.toggle_signs)
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<leader>tw', gitsigns.toggle_word_diff)
  end
})
