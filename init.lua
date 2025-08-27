require('options')
require('colors')
require('autocmds')
require('commands')
require('mappings')
require('neovide')
require('legacy')

require('lspconfig').pylsp.setup{}
require('lsp.pylsp')

require('paq-init')
require('plugins.mini')
require('plugins.barbar')
require('plugins.nvim-treesitter')
require('plugins.telescope')
require('bigfile').setup()
require('fidget').setup()
require('neogotham').setup()
require('night-owl').setup({ italics = false })
require('nvim-navbuddy').setup({ opts = { lsp = { auto_attach = true } } })
require('time-machine').setup({})

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

require('plugins.ibl-init')
