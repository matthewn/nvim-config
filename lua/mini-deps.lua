---@diagnostic disable: undefined-field, undefined-global

-- clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })
local add = MiniDeps.add

-- nvim plugins
add('LunarVim/bigfile.nvim') -- handle large files more gracefully
add('MagicDuck/grug-far.nvim') -- project-wide find and replace at :GrugFar
add({ -- git git git!
  source = 'NeogitOrg/neogit',
  depends = { 'sindrets/diffview.nvim' },
})
add('Wansmer/treesj') -- treesitter-driven :TSJToggle at <leader>j
add('chrishrb/gx.nvim') -- improved 'gx' command (includes opening github links from this file!)
add('folke/zen-mode.nvim') -- distraction-free environment (replaces goyo/vimroom)
add('folke/todo-comments.nvim') -- highlight TODO and such
add('gbprod/stay-in-place.nvim') -- improve >> and <<
add('j-hui/fidget.nvim') -- toast-like LSP messages & notifications
add('lewis6991/gitsigns.nvim') -- git in the gutter
add('lukas-reineke/indent-blankline.nvim') -- replaces vim-indent-guides
add('kylechui/nvim-surround') -- vim-surround replacement
add('mfussenegger/nvim-dap') -- debug adapter protocol client (replaces vdebug)
add('mfussenegger/nvim-dap-python') -- python debugger
add('mfussenegger/nvim-lint') -- integrates non-LSP linters (makes eslint work)
add('neovim/nvim-lspconfig') -- LSP utilities & example configurations
add('numtostr/BufOnly.nvim') -- close all buffers but current
add({ -- fuzzy finder (replaces fzf.vim)
  source = 'nvim-telescope/telescope.nvim',
  depends = { 'nvim-lua/plenary.nvim' },
})
add({ -- compiled helper, massively increases telescope performance
  source = 'nvim-telescope/telescope-fzf-native.nvim',
  hooks = {
    post_install = function(args) vim.fn.system({'make', '-C', args.path}) end,
    post_checkout = function(args) vim.fn.system({'make', '-C', args.path}) end,
  },
})
add({ -- drives neovim 0.11 treesitter configs
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end }
})
add('nvim-treesitter/nvim-treesitter-context') -- show top of long functions
add('rachartier/tiny-inline-diagnostic.nvim') -- LSP diagnostics (replaces e-kaput)
add({ -- bufferline replacement (w/ rearrangeable tabs!)
  source = 'romgrk/barbar.nvim',
  depends = { 'nvim-tree/nvim-web-devicons' },
})
add('stevearc/aerial.nvim') -- code outline window (replaces Vista.vim)
add('stevearc/conform.nvim') -- provides :Format (for black and such)
add('wsdjeg/rooter.nvim') -- auto-cd to project root
add('y3owk1n/time-machine.nvim') -- undotree replacement
add('zaldih/themery.nvim') -- colorscheme browser at :Themery

-- colorschemes
add('oahlen/iceberg.nvim')
add('oxfist/night-owl.nvim')
add('slugbyte/lackluster.nvim')
add({ source = 'https://gitlab.com/shmerl/neogotham.git' })

-- vimscript plugins, no config
add('AndrewRadev/sideways.vim') -- move arguments right/left
add('chrisbra/Colorizer') -- show hex colors, etc. with :ColorToggle
add('direnv/direnv.vim') -- direnv integration
add('gioele/vim-autoswap') -- essential: never ever bug me about swap files
add('gorkunov/smartpairs.vim') -- 'vv' for quick visual selection
add('justinmk/vim-gtfo') -- got/T for a term; gof/F for a filemanager
add('keith/investigate.vim') -- gK for vimhelp on word at cursor
add('milkypostman/vim-togglelist') -- <leader>q toggles quickfix; <leader>l toggles location
add('rbong/vim-buffest')  -- register/macro editing
add('rhysd/clever-f.vim') -- improve f and F seches; no need for ; or ,
add('thiderman/vim-reinhardt') -- for django-aware 'gf'
add('tmhedberg/SimpylFold') -- improved folding for python
add('tpope/vim-characterize') -- power-up for 'ga'
add('tpope/vim-ragtag') -- useful html-related mappings
add('tpope/vim-unimpaired') -- handy mappings
add('tweekmonster/django-plus.vim') -- django niceties

-- vimscript plugins, have config in globals.lua or elsewhere
add('Valloric/MatchTagAlways') -- html tag highlighting
add('andymass/vim-matchup') -- replaces vim's matchit plugin
add('junegunn/vim-easy-align') -- visual mode: press enter to align stuff
add('kovisoft/slimv') -- <leader>c for SBCL REPL (emacs SLIME for vim)
add('mhinz/vim-startify') -- start screen + sane sessions (replaces vim-sessionist)
