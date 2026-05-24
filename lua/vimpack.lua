---@diagnostic disable: undefined-field, undefined-global

local gh = function(repo) return 'https://github.com/' .. repo end

-- Hooks: emulate mini.deps `post_install`/`post_checkout` via `PackChanged`.
-- Must be registered BEFORE `vim.pack.add()` so install-time hooks fire.
vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Run plugin hooks after install/update',
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    if name == 'telescope-fzf-native.nvim' then
      vim.system({ 'make', '-C', ev.data.path }):wait()
    end

    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.pack.add({
  -- nvim plugins
  gh('MagicDuck/grug-far.nvim'),                  -- project-wide find and replace at :GrugFar
  gh('sindrets/diffview.nvim'),                   -- (neogit dependency)
  gh('NeogitOrg/neogit'),                         -- git git git!
  gh('Wansmer/treesj'),                           -- treesitter-driven :TSJToggle at <leader>j
  gh('chrishrb/gx.nvim'),                         -- improved 'gx' command (includes opening github links from this file!)
  gh('folke/zen-mode.nvim'),                      -- distraction-free environment (replaces goyo/vimroom)
  gh('folke/todo-comments.nvim'),                 -- highlight TODO and such
  gh('gbprod/stay-in-place.nvim'),                -- improve >> and <<
  gh('j-hui/fidget.nvim'),                        -- toast-like LSP messages & notifications
  gh('lewis6991/gitsigns.nvim'),                  -- git in the gutter
  gh('lukas-reineke/indent-blankline.nvim'),      -- replaces vim-indent-guides
  gh('kylechui/nvim-surround'),                   -- vim-surround replacement
  gh('mfussenegger/nvim-dap'),                    -- debug adapter protocol client (replaces vdebug)
  gh('mfussenegger/nvim-dap-python'),             -- python debugger
  gh('mfussenegger/nvim-lint'),                   -- integrates non-LSP linters (makes eslint work)
  gh('nvim-mini/mini.nvim'),                      -- mini.* library (icons, files, completion, statusline, map, ...)
  gh('neovim/nvim-lspconfig'),                    -- LSP utilities & example configurations
  gh('numtostr/BufOnly.nvim'),                    -- close all buffers but current
  gh('nvim-lua/plenary.nvim'),                    -- (telescope dependency)
  gh('nvim-telescope/telescope.nvim'),            -- fuzzy finder (replaces fzf.vim)
  gh('nvim-telescope/telescope-fzf-native.nvim'), -- compiled helper, massively increases telescope performance (see PackChanged above)
  gh('nvim-treesitter/nvim-treesitter'),          -- drives treesitter configs (see PackChanged above)
  gh('nvim-treesitter/nvim-treesitter-context'),  -- show top of long functions
  gh('pteroctopus/faster.nvim'),                  -- handle large files more gracefully (replaces bigfile.nvim)
  gh('rachartier/tiny-inline-diagnostic.nvim'),   -- LSP diagnostics (replaces e-kaput)
  gh('nvim-tree/nvim-web-devicons'),              -- (barbar dependency)
  gh('romgrk/barbar.nvim'),                       -- bufferline replacement (w/ rearrangeable tabs!)
  gh('stevearc/aerial.nvim'),                     -- code outline window (replaces Vista.vim)
  gh('stevearc/conform.nvim'),                    -- provides :Format (for black and such)
  gh('wsdjeg/rooter.nvim'),                       -- auto-cd to project root
  gh('zaldih/themery.nvim'),                      -- colorscheme browser at :Themery

  -- colorschemes
  gh('oahlen/iceberg.nvim'),
  gh('oxfist/night-owl.nvim'),
  gh('slugbyte/lackluster.nvim'),
  { src = 'https://gitlab.com/shmerl/neogotham.git', name = 'neogotham' },

  -- vimscript plugins, no config
  gh('AndrewRadev/sideways.vim'),                 -- move arguments right/left
  gh('chrisbra/Colorizer'),                       -- show hex colors, etc. with :ColorToggle
  gh('direnv/direnv.vim'),                        -- direnv integration
  gh('gioele/vim-autoswap'),                      -- essential: never ever bug me about swap files
  gh('gorkunov/smartpairs.vim'),                  -- 'vv' for quick visual selection
  gh('justinmk/vim-gtfo'),                        -- got/T for a term; gof/F for a filemanager
  gh('milkypostman/vim-togglelist'),              -- <leader>q toggles quickfix; <leader>l toggles location
  gh('rbong/vim-buffest'),                        -- register/macro editing
  gh('rhysd/clever-f.vim'),                       -- improve f and F seches; no need for ; or ,
  gh('thiderman/vim-reinhardt'),                  -- for django-aware 'gf'
  gh('tpope/vim-characterize'),                   -- power-up for 'ga'
  gh('tpope/vim-ragtag'),                         -- useful html-related mappings
  gh('tpope/vim-unimpaired'),                     -- handy mappings
  gh('tweekmonster/django-plus.vim'),             -- django niceties

  -- vimscript plugins, have config in globals.lua or elsewhere
  gh('Valloric/MatchTagAlways'),                  -- html tag highlighting
  gh('andymass/vim-matchup'),                     -- replaces vim's matchit plugin
  gh('junegunn/vim-easy-align'),                  -- visual mode: press enter to align stuff
  gh('kovisoft/slimv'),                           -- <leader>c for SBCL REPL (emacs SLIME for vim)
  gh('mhinz/vim-startify'),                       -- start screen + sane sessions (replaces vim-sessionist)
})
