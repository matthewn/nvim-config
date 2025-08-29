vim.g.barbar_auto_setup = false

if vim.g.neovide then
  require('barbar').setup {
    -- show filetype icons but no close buttons
    icons = { button = false },
  }
else
  require('barbar').setup {
    -- show no filetype icons or close buttons
    icons = { button = false, filetype = { enabled = false } },
  }
end
