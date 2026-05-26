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
