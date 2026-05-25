---@diagnostic disable: undefined-field

require('mini.icons').setup()
require('mini.splitjoin').setup()
require('mini.statusline').setup({ use_icons = vim.g.neovide ~= nil })


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


-- mini.completion: lightweight, nearly setup-free completion that *behaves*
local completion = require('mini.completion')
completion.setup({
  delay = { completion = 200, info = 400, signature = 1200 },
  lsp_completion = {
    enabled = function()
      local ft = vim.bo.filetype
      if ft == 'html' or ft == 'htmldjango' or ft == 'markdown' then
        return false
      end
      return true
    end,
  },
  fallback_action = function()
    local ft = vim.bo.filetype
    if ft == 'markdown' then
      -- do nothing for markdown fallback
      return nil
    end
    -- default behavior for everything else (usually <C-n>)
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n', true)
  end,
})

-- smart tab functions (for keymaps below)
local function smart_tab()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes('<c-n>', true, true, true)
  end
  local ok, mini_completion = pcall(require, 'mini.completion')
  if ok and mini_completion and mini_completion.complete then
    if mini_completion.complete() then
      return '' -- completion opened
    end
  end
  return vim.api.nvim_replace_termcodes('<tab>', true, true, true)
end

local function smart_s_tab()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes('<c-p>', true, true, true)
  end
  return vim.api.nvim_replace_termcodes('<s-tab>', true, true, true)
end

vim.keymap.set('i', '<tab>', smart_tab, { expr = true, desc = 'Smart tab completion' })
vim.keymap.set('i', '<s-tab>', smart_s_tab, { expr = true, desc = 'Smart shift-tab completion' })
vim.keymap.set('i', '<cr>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', { expr = true, desc = 'Smart enter (accept completion)' })


-- mini.trailspace: show / remove trailing whitespace
require('mini.trailspace').setup()
local augroup = vim.api.nvim_create_augroup('mini.trailspace', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  callback = function()
    vim.api.nvim_set_hl(0, 'MiniTrailspace', { bg = '#660000', fg = 'NONE' }) -- dark red
  end,
})
vim.keymap.set('n', '<leader>TT', function()
  require('mini.trailspace').trim()
end, { silent = true, desc = 'Trim trailing whitespace' })


-- mini.files: ** !! miller column filer !! **
require('mini.files').setup({
  mappings = {
    close       = 'q',
    go_in       = 'L',
    go_in_plus  = '<enter>',
    go_out      = 'H',
    go_out_plus  = '',
    synchronize = '<tab>',
  },
  content = { prefix = function() end }, -- disable icons
})

-- helper: find project root
local function get_project_root()
  local client = vim.lsp.get_clients({ bufnr = 0 })[1]
  if client and client.config.root_dir then
    return client.config.root_dir
  end

  local root = vim.fs.root(0, { '.git', 'Makefile', 'package.json', 'pyproject.toml' })
  if root then
    return root
  end

  return vim.uv.cwd() -- fallback
end

-- helper: open mini.files at a given path
local function open_files(path)
  require('mini.files').open(path, false)
end

-- map <leader>n to project root
vim.keymap.set('n', '<leader>n', function()
  open_files(get_project_root())
end, { desc = 'Open mini.files at project root' })

-- map <leader>N to current file's directory
vim.keymap.set('n', '<leader>N', function()
  open_files(vim.fn.expand('%:p:h'))
end, { desc = 'Open mini.files at current file directory' })


-- mini.map: scrollbars + minimap
local minimap = require('mini.map')

minimap.setup({
  integrations = {
    require('mini.map').gen_integration.builtin_search(),
    require('mini.map').gen_integration.gitsigns(),
    require('mini.map').gen_integration.diagnostic({
      error = 'DiagnosticFloatingError',
      warn  = 'DiagnosticFloatingWarn',
      info  = 'DiagnosticFloatingInfo',
      hint  = 'DiagnosticFloatingHint',
    }),
  },
  symbols = {
    encode = require('mini.map').gen_encode_symbols.dot('4x2'),
    scroll_line = '█',
    scroll_view = '┃',
  },
  window = { show_integration_count = false, width = 1 }
})

-- auto-open width-1 map (scrollbar only) on most buffers
local mapgroup = vim.api.nvim_create_augroup('mini.map', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = mapgroup,
  callback = function(args)
    local buftype = vim.bo[args.buf].buftype
    local filetype = vim.bo[args.buf].filetype
    -- skip special buffers; only apply to regular buffers
    if buftype == '' and filetype ~= '' then
      require('mini.map').open()
    end
  end,
})

-- helper: get minimap window width
local function get_minimap_width()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'minimap' then
      return vim.api.nvim_win_get_width(win)
    end
  end
  return nil -- minimap window not found
end

-- keymap to toggle minimap width
vim.keymap.set('n', '<leader>M', function()
  local width = get_minimap_width()
  -- fallback to configured width if minimap not open
  width = width or minimap.config.window.width
  if width == 1 then
    minimap.open({ window = { width = 12 } })
  else
    minimap.open({ window = { width = 1 } })
  end
end, { desc = 'Toggle minimap width' })
