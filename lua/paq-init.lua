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
  'LunarVim/lunar.nvim', -- colorscheme
  'MagicDuck/grug-far.nvim', -- project-wide find and replace at :GrugFar
  'MunifTanjim/nui.nvim', -- req'd by navbuddy
  'SmiteshP/nvim-navic', -- req'd by navbuddy
  'echasnovski/mini.nvim', -- multi-tool: files, statusline & more
  'hasansujon786/nvim-navbuddy', -- lsp-powered popup code tree browser
  'https://gitlab.com/shmerl/neogotham.git', -- colorscheme
  'j-hui/fidget.nvim', -- toast-like lsp messages & notifications
  'lukas-reineke/indent-blankline.nvim', -- replaces vim-indent-guides
  'neovim/nvim-lspconfig', -- handle LSP configuration
  'numtostr/BufOnly.nvim', -- close all buffers but current
  'nvim-lua/plenary.nvim', -- used by telescope
  'nvim-telescope/telescope.nvim', -- fuzzy finder
  'nvim-tree/nvim-web-devicons', -- used by barbar, mini.icons, etc.
  'oxfist/night-owl.nvim', -- colorscheme
  'romgrk/barbar.nvim', -- bufferline replacement
  'wsdjeg/rooter.nvim', -- auto-cd to project root
  'y3owk1n/time-machine.nvim', -- undotree replacement
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- vimscript plugins, no config
  'AndrewRadev/sideways.vim', -- move arguments right/left
  'Vimjas/vim-python-pep8-indent', -- fix python indenting
  'cakebaker/scss-syntax.vim', -- essential: syntax for scss
  'chrisbra/Colorizer', -- show hex colors, etc. with :ColorToggle
  'cocopon/iceberg.vim', -- colorscheme
  'dhruvasagar/vim-open-url', -- gB to open url
  'fcpg/vim-orbital', -- colorscheme
  'gioele/vim-autoswap', -- essential: never ever bug me about swap files
  'gorkunov/smartpairs.vim', -- 'vv' for quick visual selection
  'hail2u/vim-css3-syntax', -- essential: syntax for css3
  'jlanzarotta/colorSchemeExplorer', -- does what it says on the tin
  'justinmk/vim-gtfo', -- got/T for a term; gof/F for a filemanager
  'junegunn/goyo.vim', -- replaces vimroom
  'junegunn/gv.vim', -- git browser at :GV :GV! :GV? (replaces cohama/agit.vim for now)
  'keith/investigate.vim', -- gK for vimhelp on word at cursor
  'milkypostman/vim-togglelist', -- <leader>q toggles quickfix; <leader>l toggles location
  'rbong/vim-buffest',  -- register/macro editing
  'rhysd/clever-f.vim', -- improve f and F searches; no need for ; or ,
  'thiderman/vim-reinhardt', -- for django-aware 'gf'
  'tmhedberg/SimpylFold', -- improved folding for python
  'tpope/vim-characterize', -- power-up for 'ga'
  'tpope/vim-fugitive', -- essential: git gateway
  'tpope/vim-ragtag', -- useful html-related mappings
  'tpope/vim-repeat', -- makes vim-surround better
  'tpope/vim-surround', -- essential
  'tpope/vim-unimpaired', -- handy mappings
  'tweekmonster/django-plus.vim', -- django niceties
  'vim-python/python-syntax', -- improved python syntax highlighting
  'xuhdev/vim-latex-live-preview', -- what it says on the tin

  -- vimscript plugins, have config in legacy.lua
  'Valloric/MatchTagAlways',
  'andymass/vim-matchup',
  'junegunn/vim-easy-align',
  'kovisoft/slimv',
  'ludovicchabant/vim-gutentags',
  'mhinz/vim-startify',
  'vim-vdebug/vdebug',
}
