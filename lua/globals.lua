-- config for global vars
-- (mostly for legacy vimscripts)

-- set global python location to quiet errors relating to pynvim
-- not being installed in every venv we have
vim.g.python3_host_prog = '/usr/bin/python3'

-- MatchTagAlways
vim.g.mta_filetypes = {
  html  = 1,
  xhtml = 1,
  xml   = 1,
  twig  = 1,
  php   = 1,
}
vim.g.mta_use_matchparen_group = 0

-- slimv
vim.g.lisp_rainbow = 1
vim.g.slimv_repl_split = 2 -- REPL below code

-- vdebug
vim.g.vdebug_options = { break_on_open = 0 }
vim.g.vdebug_keymap = {
  run            = '<leader>D',
  run_to_cursor  = '<Down>',
  step_over      = '<Up>',
  step_into      = '<Right>',
  step_out       = '<Left>',
  close          = '<F4>',
  detach         = '<F5>',
  set_breakpoint = '<leader>p',
  eval_visual    = '<leader>E',
}

-- vim-gutentags
vim.g.gutentags_cache_dir = vim.fn.stdpath('data') .. '/tags'

-- vim-matchup
vim.g.matchup_transmute_enabled = 1 -- enable paired tag renaming (replaces tagalong)

-- vim-startify
local function tweaked_sessions_list()
  local sessions = vim.fn['startify#session_list']('')
  local items = {}
  for _, s in ipairs(sessions) do
    table.insert(
      items,
      s == 'init' and 1 or #items + 1, -- 'init' session goes 1st
      { line = s, cmd = 'SLoad ' .. s, type = 'session' }
    )
  end
  return items
end

vim.g.startify_bookmarks = {
  { b = '~/.bashrc' },
}
vim.g.startify_lists = {
  { type = tweaked_sessions_list, header = {'   Sessions'} },
  { type = 'files', header = { '   MRU' } },
  { type = 'bookmarks', header = { '   Bookmarks' } },
  { type = 'commands', header = { '   Commands' } }, -- unused for now
}
vim.g.startify_session_persistence = 1
vim.g.startify_files_number = 5
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_dir = vim.fn.stdpath('data') .. '/sessions'
