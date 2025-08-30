require('mini.completion').setup()
require('mini.git').setup()
require('mini.icons').setup()
require('mini.splitjoin').setup()
require('mini.statusline').setup({ use_icons = vim.g.neovide and true or false })


-- mini.completion: lightweight, nearly setup-free completion that *behaves*
local completion = require('mini.completion')
completion.setup({ delay = { completion = 200 } })

-- smart tab functions (for keymaps below)
local function smart_tab()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes('<C-n>', true, true, true)
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

vim.keymap.set('i', '<tab>', smart_tab, { expr = true })
vim.keymap.set('i', '<s-tab>', smart_s_tab, { expr = true })
vim.keymap.set('i', '<cr>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', { expr = true })

-- mini.trailspace: show / remove trailing whitespace
require('mini.trailspace').setup()
local augroup = vim.api.nvim_create_augroup('mini.trailspace', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  callback = function()
    vim.api.nvim_set_hl(0, 'MiniTrailspace', { bg = '#660000', fg = 'NONE' }) -- dark red
  end,
})
vim.keymap.set('n', '<leader>SS', function()
  require('mini.trailspace').trim()
end, { silent = true, desc = 'Trim trailing whitespace' })


-- mini.files: the incredible miller column filer!
require('mini.files').setup({
  mappings = {
    go_in_plus  = '<enter>',
    synchronize = '<tab>',
  },
  content = { prefix = function() end }, -- disable icons
})

-- helper to find project root
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

-- open mini.files at a given path
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
