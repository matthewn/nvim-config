require('mini.completion').setup()
require('mini.git').setup()
require('mini.icons').setup()
require('mini.statusline').setup({ use_icons = vim.g.neovide and true or false })

require('mini.files').setup({
  mappings = { go_in_plus  = '<Enter>' },
  content = { prefix = function() end }, -- no icons
})

-- helper to find project root
local function get_project_root()
  local cwd = vim.fn.getcwd()
  local file = vim.api.nvim_buf_get_name(0)

  -- use LSP root if available
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
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
