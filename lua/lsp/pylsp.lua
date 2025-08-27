vim.lsp.config('pylsp', {
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
})
