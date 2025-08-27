local lspconfig = require('lspconfig')

lspconfig.pylsp.setup({
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_dir = lspconfig.util.root_pattern(
    'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git'
  ),
  settings = {
    pylsp = {
      configurationSources = { 'flake8' }, -- use ~/.config/flake8
      plugins = {
        flake8 = { enabled = true },
        jedi_completion = {
          enabled = true,
          eager = true,
        },
        mccabe = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
      },
    },
  },
  capabilities = capabilities,
})
