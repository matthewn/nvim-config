vim.lsp.config('pylsp', {
  settings = {
    autostart = false, -- will start AFTER direnv is done
    pylsp = {
      configurationSources = { 'flake8' }, -- use ~/.config/flake8
      plugins = {
        ruff = {
          -- ensure fallback/global config can always be found
          config = vim.fn.expand('~/.config/ruff/pyproject.toml'),
          enabled = true,
          reportCode = true,
        },
        jedi_completion = {
          enabled = true,
          eager = true,
        },
        flake8 = { enabled = false },
        mccabe = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
      },
    },
  },
})

vim.lsp.enable('pylsp')

-- restart the LSP after direnv is done
local augroup = vim.api.nvim_create_augroup('lsp-restart', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'DirenvLoaded',
  callback = function()
    if vim.bo.filetype ~= 'python' then return end

    vim.defer_fn(function()
      local clients = vim.lsp.get_clients({ name = 'pylsp', bufnr = 0 })
      if #clients > 0 then
        vim.cmd('LspRestart pylsp')
      end
    end, 100)
  end,
})
