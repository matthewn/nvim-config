-- settings
require('options')
require('colors')
require('autocmds')
require('commands')
require('keymaps')
require('neovide')

-- LSP
require('lsp.lua_ls')
require('lsp.pylsp')
require('lsp.stylelint_lsp')

-- plugins
require('paq-init')
require('legacy')
require('plugins.aerial')
require('plugins.barbar')
require('plugins.codewindow')
require('plugins.conform')
require('plugins.gitsigns')
require('plugins.ibl-init')
require('plugins.mini')
require('plugins.nvim-lint')
require('plugins.nvim-treesitter')
require('plugins.telescope')
require('plugins.todo-comments')
require('plugins.themery')
require('bigfile').setup()
require('fidget').setup()
require('neogit').setup()
require('neogotham').setup()
require('night-owl').setup({ italics = false })
require('nvim-surround').setup()
require('rooter').setup()
require('scrollview').setup()
require('time-machine').setup({})

if vim.fn.has('vim_starting') == 1 then
  local ok = pcall(vim.cmd.colorscheme, 'neogotham')
  if not ok then
    vim.cmd.colorscheme('darkblue')
  end
  vim.o.background = 'dark'

  if vim.g.neovide then
    vim.opt.lines = 46
    vim.opt.columns = 90
    vim.opt.guifont = 'Ubuntu Mono:h16'
  end
end
