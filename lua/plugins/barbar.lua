vim.g.barbar_auto_setup = false
local keymap = vim.keymap.set
local opts = { silent = true }

if vim.g.neovide then
  require('barbar').setup {
    icons = { button = false },
  }
  keymap('n', '<C-Tab>', '<Cmd>BufferNext<CR>', opts)
  keymap('n', '<C-S-Tab>', '<Cmd>BufferPrevious<CR>', opts)
else
  require('barbar').setup {
    icons = { button = false, filetype = { enabled = false } },
  }
  keymap('n', 'gbn', '<Cmd>BufferNext<CR>', opts)
  keymap('n', 'gbp', '<Cmd>BufferPrevious<CR>', opts)
end
