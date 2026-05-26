-- mini.sessions: named sessions (replaces vim-startify's session manager)
require('mini.sessions').setup({
  directory = vim.fn.stdpath('data') .. '/sessions',
  file = '', -- no per-directory local session; named sessions only, like startify
  autowrite = true, -- persist active session on exit (replaces startify_session_persistence)
  hooks = {
    pre = {
      write = function()
        -- necessary to save barbar tab order
        vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePre' })
      end,
    },
  },
})

-- 'save session' keymap
vim.keymap.set('n', '<leader>SS', function()
  local ms = require('mini.sessions')
  if vim.v.this_session ~= '' then
    ms.write(nil, { force = true }) -- re-save the active session
  else
    vim.ui.input({ prompt = 'Save session as: ' }, function(name)
      if name and name ~= '' then ms.write(name, { force = true }) end
    end)
  end
end, { desc = 'Save session' })

-- 'exit session' keymap
vim.keymap.set('n', '<leader>XX', function()
  local listed = vim.tbl_filter(function(b)
    return vim.fn.buflisted(b) == 1
  end, vim.api.nvim_list_bufs())
  for _, b in ipairs(listed) do
    if vim.bo[b].modified then
      vim.notify('Save modified buffers first', vim.log.levels.WARN)
      return
    end
  end

  local had_session = vim.v.this_session ~= ''
  if had_session then
    require('mini.sessions').write(nil, { force = true }) -- save the session
    vim.v.this_session = '' -- detach so further edits aren't auto-saved
  end

  require('mini.starter').open() -- land on the start screen
  for _, b in ipairs(listed) do -- wipe the (former) buffers
    if vim.api.nvim_buf_is_valid(b) then
      vim.api.nvim_buf_delete(b, { force = true })
    end
  end
  vim.notify(had_session and 'Session closed' or 'Buffers cleared')
end, { desc = 'Close session / clear buffers' })
