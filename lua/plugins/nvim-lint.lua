local lint = require('lint')

-- Extend the eslint linter to always add --foobar
lint.linters.eslint.args = {
  '--config', vim.fn.expand('~/.config/eslint/eslint.config.js'),
  '--no-color', -- defaults from here to end of table
  '--format',
  'json',
  '--stdin',
  '--stdin-filename',
  function() return vim.api.nvim_buf_get_name(0) end,
}

lint.linters_by_ft = {
  javascript = { 'eslint' },
}

vim.api.nvim_create_autocmd(  { 'TextChanged', 'TextChangedI', 'BufReadPost', 'BufWritePost' }, {
  pattern = { '*.js' }, -- only operate on js files for now
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    lint.try_lint()
    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    -- require('lint').try_lint('cspell')
  end,
})
