vim.lsp.config('pylsp', {
  settings = {
    autostart = false, -- will start AFTER direnv is done
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

vim.lsp.enable('pylsp')

-- restart the LSP after direnv is done
local augroup = vim.api.nvim_create_augroup('lsp-restart', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'DirenvLoaded',
  callback = function()
    -- small delay to ensure environment is fully loaded
    vim.defer_fn(function()
      -- only restart if we have LSP clients attached
      if next(vim.lsp.get_clients()) then
        vim.cmd("LspRestart")
      end
    end, 100)
  end,
})
