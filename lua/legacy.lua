-- config for legacy vimscripts that use vim.g for such

-- MatchTagAlways - html tag highlighting
vim.g.mta_filetypes = {
  html  = 1,
  xhtml = 1,
  xml   = 1,
  twig  = 1,
  php   = 1,
}
vim.g.mta_use_matchparen_group = 0

-- slimv - <leader>c for SBCL REPL (emacs SLIME for vim)
vim.g.lisp_rainbow = 1
vim.g.slimv_repl_split = 2 -- REPL below code

-- vdebug - modern vim debugger
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

-- vim-gutentags - essential automated ctags mgr (replaces vim-easytags)
vim.g.gutentags_cache_dir = vim.fn.stdpath('data') .. '/tags'

-- vim-matchup - replaces vim's matchit plugin
vim.g.matchup_transmute_enabled = 1 -- enable paired tag renaming (replaces tagalong)

-- vim-rooter - auto cwd to project root
vim.g.rooter_silent_chdir = 1

-- vim-startify - start screen + sane sessions (replaces vim-sessionist)
vim.g.startify_bookmarks = {
  { b = '~/.bashrc' },
  { v = vim.env.MYVIMRC },
}
vim.g.startify_lists = {
  { type = 'sessions',  header = { '   Sessions' } },
  { type = 'bookmarks', header = { '   Bookmarks' } },
  { type = 'files',     header = { '   MRU' } },
  { type = 'commands',  header = { '   Commands' } },
}
vim.g.startify_session_persistence = 1
vim.g.startify_files_number = 5
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_dir = vim.fn.stdpath('data') .. '/sessions'
