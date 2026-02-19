-- settings
require('options')
require('globals')
require('colors')
require('autocmds')
require('commands')
require('keymaps')
require('neovide')

-- LSP
require('lsp.djls')
require('lsp.lua_ls')
require('lsp.python')
require('lsp.stylelint_lsp')

-- plugins
require('mini-deps')
require('plugins.aerial')
require('plugins.barbar')
require('plugins.conform')
require('plugins.gitsigns')
require('plugins.gx')
require('plugins.ibl-init')
require('plugins.mini')
require('plugins.nvim-dap')
require('plugins.nvim-lint')
require('plugins.telescope')
require('plugins.tiny-inline-diagnostic')
require('plugins.todo-comments')
require('plugins.themery')
require('plugins.treesj')
require('plugins.zen-mode')
require('bigfile').setup()
require('fidget').setup()
require('neogit').setup({ graph_style = 'unicode' })
require('neogotham').setup()
require('night-owl').setup({ italics = false })
require('nvim-surround').setup()
require('rooter').setup()
require('time-machine').setup({})

-- startup
if vim.fn.has('vim_starting') == 1 then
  --colorscheme
  local ok = pcall(vim.cmd.colorscheme, 'neogotham')
  if not ok then
    vim.cmd.colorscheme('darkblue')
  end
  vim.o.background = 'dark'

  -- neovide-only
  if vim.g.neovide then
    vim.opt.lines = 46
    vim.opt.columns = 90
    vim.opt.guifont = 'Ubuntu Mono:h16'
  end
end
