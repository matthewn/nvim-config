vim.lsp.config('pyright', {
  handlers = {
    -- drop pyright's diagnostics entirely (we use ruff instead)
    ['textDocument/publishDiagnostics'] = function() end,
  },
  settings = {
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
          -- Safely stop the active clients
          for _, client in ipairs(clients) do
            local config = client.config
            vim.lsp.stop_client(client.id, true) -- true forces immediate shutdown
            
            -- Small delay to let the OS kill the process before restarting it
            vim.defer_fn(function()
              vim.lsp.start(config)
            end, 50)
          end
        else
          -- Fallback if server wasn't running yet
          local config = vim.lsp.config[server]
          if config then
            vim.lsp.start(config)
          end
        end
      end
    end, 100)
  end,
})
