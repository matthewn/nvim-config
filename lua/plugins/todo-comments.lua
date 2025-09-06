require('todo-comments').setup({
  signs = false, -- no icons in the signs column
  -- TODO things
  -- FIXME more things
  highlight = {
    multiline = false,
    before = '',
    keyword = 'bg',
    after = '',
    pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    exclude = {}, -- list of file types to exclude highlighting
  },
})
