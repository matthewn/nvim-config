vim.g.barbar_auto_setup = false
require('barbar').setup {
  -- show filetype icons if gui; no close buttons ever
  icons = { button = false, filetype = { enabled = vim.g.neovide and true or false } },
}
