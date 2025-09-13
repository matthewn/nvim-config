require'nvim-treesitter.configs'.setup {
  -- a list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = {
    'css',
    'html',
    'htmldjango',
    'javascript',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'scss',
    'query',
    'vim',
    'vimdoc',
  },

  -- automatically install missing parsers when entering buffer
  -- recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
