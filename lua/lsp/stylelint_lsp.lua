vim.lsp.config('stylelint_lsp', {
  settings = {
    stylelintplus = {
      -- see available options in stylelint-lsp documentation
    }
  }
})

vim.lsp.enable('stylelint_lsp')
