require('mini.icons').setup()
require('mini.splitjoin').setup()
require('mini.statusline').setup({ use_icons = vim.g.neovide ~= nil })


-- mini.completion: lightweight, nearly setup-free completion that *behaves*
local completion = require('mini.completion')
completion.setup({
  delay = { completion = 200, info = 400, signature = 1200 },
  lsp_completion = {
    enabled = function()
      local ft = vim.bo.filetype
      -- disable for html and htmldjango
      if ft == 'html' or ft == 'htmldjango' then
        return false
      end
      return true
    end,
  },
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
  local cwd = vim.fn.getcwd()

  -- use LSP root if available
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if next(clients) ~= nil then
    local lsp_root = clients[1].config.root_dir
    if lsp_root ~= nil then
      return lsp_root
    end
  end

  -- otherwise, search upwards for git repo
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.fnameescape(vim.fn.expand('%:p:h')) .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error == 0 then
    return git_root
  end

  -- fallback: current working directory
  return cwd
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
