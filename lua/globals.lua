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

-- vim-gutentags
vim.g.gutentags_cache_dir = vim.fn.stdpath('data') .. '/tags'

-- vim-matchup
vim.g.matchup_transmute_enabled = 1 -- enable paired tag renaming (replaces tagalong)
