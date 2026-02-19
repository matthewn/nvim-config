vim.lsp.config('pyright', {
  handlers = {
    -- drop pyright's diagnostics entirely (we use ruff instead)
    ['textDocument/publishDiagnostics'] = function() end,
  },
  settings = {
    autostart = false, -- wait for direnv
    python = {
      analysis = {
        -- enable completions and indexing
        autoImportCompletions = true,
        indexing = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config('ruff', {
  settings = {
    autostart = false, -- wait for direnv
  },
})

vim.lsp.enable('pyright')
vim.lsp.enable('ruff')

local augroup = vim.api.nvim_create_augroup('lsp-restart', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'DirenvLoaded',
  callback = function()
    if vim.bo.filetype ~= 'python' then return end

    vim.defer_fn(function()
      -- restart both pyright and ruff so they see the new sys.path/venv
      local target_servers = { 'pyright', 'ruff' }
      for _, server in ipairs(target_servers) do
        local clients = vim.lsp.get_clients({ name = server, bufnr = 0 })
        if #clients > 0 then
          vim.cmd('LspRestart ' .. server)
        else
          -- if it wasn't started yet because of autostart = false
          vim.cmd('LspStart ' .. server)
        end
      end
    end, 100)
  end,
})
