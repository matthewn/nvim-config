vim.g.barbar_auto_setup = false

if vim.g.neovide then
  require('barbar').setup {
    icons = { button = false },
  }
else
  require('barbar').setup {
    icons = { button = false, filetype = { enabled = false } },
  }
end
