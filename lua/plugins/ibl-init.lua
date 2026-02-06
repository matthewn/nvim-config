local function setup_ibl()
  -- safely handle cases where colors_name isn't set yet
  local current_theme = vim.g.colors_name or ''
  local highlight

  if vim.tbl_contains({'night-owl', 'neogotham'}, current_theme) then
    highlight = {
      'CursorLineFold',
      'StatusLineNC',
    }
  else
    highlight = {
      'CursorColumn',
      'Whitespace',
    }
  end

  require('ibl').setup {
    exclude = { filetypes = { 'startify' } },
    indent = { highlight = highlight, char = '' },
    whitespace = {
      highlight = highlight,
      remove_blankline_trail = false,
    },
    scope = { enabled = false },
  }
end

-- run once on startup to initialize
setup_ibl()

-- run on colorscheme change
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('IBLConfig', { clear = true }),
  callback = function()
    setup_ibl()
  end,
})
