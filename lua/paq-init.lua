local function clone_paq()
  local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
  local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
  if not is_installed then
    vim.fn.system { 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', path }
    return true
  end
end

local function bootstrap_paq(packages)
  local first_install = clone_paq()
  vim.cmd.packadd('paq-nvim')
  local paq = require('paq')
  if first_install then
    vim.notify('Installing plugins... If prompted, hit Enter to continue.')
  end

  -- read and install packages
  paq(packages)
  paq.install()
end

bootstrap_paq {
  -- nvim plugins
  'savq/paq-nvim',
  'LunarVim/bigfile.nvim', -- handle large files more gracefully
  'MagicDuck/grug-far.nvim', -- project-wide find and replace at :GrugFar
  'NeogitOrg/neogit', -- git git git
  'chrishrb/gx.nvim', -- improved 'gx' command (includes opening github links from this file!)
  'folke/todo-comments.nvim', -- highlight TODO and such
  'j-hui/fidget.nvim', -- toast-like lsp messages & notifications
  'lewis6991/gitsigns.nvim', -- git in the gutter
  'lukas-reineke/indent-blankline.nvim', -- replaces vim-indent-guides
  'kylechui/nvim-surround', -- vim-surround replacement
  'mfussenegger/nvim-lint', -- integrates non-LSP linters (makes eslint work)
  'neovim/nvim-lspconfig', -- LSP utilities & example configurations
  'numtostr/BufOnly.nvim', -- close all buffers but current
  'nvim-lua/plenary.nvim', -- used by telescope
  'nvim-mini/mini.nvim', -- multi-tool: files, statusline, completion & more
  'nvim-telescope/telescope.nvim', -- fuzzy finder
  'nvim-tree/nvim-web-devicons', -- used by barbar, mini.icons, etc.
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' }, -- drives neovim 0.11 lsp configs
  'nvim-treesitter/nvim-treesitter-context', -- show top of long functions
  'romgrk/barbar.nvim', -- bufferline replacement w/ rearrangeable tabs
  'sindrets/diffview.nvim', -- used with neogit
  'stevearc/aerial.nvim', -- code outline window
  'stevearc/conform.nvim', -- :Format (for black and such)
  { 'volvofixthis/e-kaput.nvim', branch = 'fixes' }, -- floating lsp diagnostics
  'wsdjeg/rooter.nvim', -- auto-cd to project root
  'y3owk1n/time-machine.nvim', -- undotree replacement
  'zaldih/themery.nvim', -- colorscheme browser at :Themery

  -- colorschemes
  'oahlen/iceberg.nvim',
  'oxfist/night-owl.nvim',
  'https://gitlab.com/shmerl/neogotham.git',

  -- vimscript plugins, no config
  'AndrewRadev/sideways.vim', -- move arguments right/left
  'Vimjas/vim-python-pep8-indent', -- fix python indenting
  'cakebaker/scss-syntax.vim', -- essential: syntax for scss (non-ts)
  'chrisbra/Colorizer', -- show hex colors, etc. with :ColorToggle
  'direnv/direnv.vim', -- direnv integration
  'gioele/vim-autoswap', -- essential: never ever bug me about swap files
  'gorkunov/smartpairs.vim', -- 'vv' for quick visual selection
  'hail2u/vim-css3-syntax', -- essential: syntax for css3 (non-ts)
  'justinmk/vim-gtfo', -- got/T for a term; gof/F for a filemanager
  'junegunn/goyo.vim', -- replaces vimroom
  'keith/investigate.vim', -- gK for vimhelp on word at cursor
  'milkypostman/vim-togglelist', -- <leader>q toggles quickfix; <leader>l toggles location
  'rbong/vim-buffest',  -- register/macro editing
  'rhysd/clever-f.vim', -- improve f and F searches; no need for ; or ,
  'thiderman/vim-reinhardt', -- for django-aware 'gf'
  'tmhedberg/SimpylFold', -- improved folding for python
  'tpope/vim-characterize', -- power-up for 'ga'
  'tpope/vim-ragtag', -- useful html-related mappings
  'tpope/vim-unimpaired', -- handy mappings
  'tweekmonster/django-plus.vim', -- django niceties
  'vim-python/python-syntax', -- improved python syntax highlighting (non-ts)

  -- vimscript plugins, have config in globals.lua
  'Valloric/MatchTagAlways', -- html tag highlighting
  'andymass/vim-matchup', -- replaces vim's matchit plugin
  'junegunn/vim-easy-align', -- visual mode: press enter to align stuff
  'kovisoft/slimv', -- <leader>c for SBCL REPL (emacs SLIME for vim)
  'ludovicchabant/vim-gutentags', -- essential automated ctags mgr (replaces vim-easytags)
  'mhinz/vim-startify', -- start screen + sane sessions (replaces vim-sessionist)
  'vim-vdebug/vdebug', -- modern vim debugger
}
