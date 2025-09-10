require('todo-comments').setup({
  -- let's see them right here:
  -- TODO stuff
  -- FIXME: more stuff
  signs = false, -- no icons in the signs column
  highlight = {
    multiline = false,
    before = '',
    keyword = 'bg',
    after = '',
    pattern = [[ (KEYWORDS):? ]], -- pattern or table of patterns, used for highlighting (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    exclude = {}, -- list of file types to exclude highlighting
  },
})
