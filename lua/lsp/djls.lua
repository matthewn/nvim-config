vim.lsp.config('djls', {
  cmd = { 'djls', 'serve' },
  filetypes = { 'htmldjango' },
  root_markers = { 'manage.py', 'pyproject.toml', '.git' },
})

vim.lsp.enable('djls')
