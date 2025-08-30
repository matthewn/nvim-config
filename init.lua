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
require('plugins.aerial')
require('plugins.barbar')
require('plugins.codewindow')
require('plugins.mini')
require('plugins.nvim-lint')
require('plugins.nvim-treesitter')
require('plugins.telescope')
require('bigfile').setup()
require('fidget').setup()
require('neogotham').setup()
require('night-owl').setup({ italics = false })
require('nvim-navbuddy').setup({ lsp = { auto_attach = true } })
require('rooter').setup()
require('time-machine').setup({})
require('legacy')

require('plugins.ibl-init')

if vim.fn.has('vim_starting') == 1 then
  local ok = pcall(vim.cmd.colorscheme, 'night-owl')
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

