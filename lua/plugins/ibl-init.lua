local highlight
if vim.tbl_contains({'night-owl', 'neogotham'}, vim.g.colors_name) then
  highlight = {
    'StatusLineNC',
    'Visual',
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
