require('tiny-inline-diagnostic').setup({
  options = {
    overwrite_events = { 'LspAttach', 'BufEnter', 'DiagnosticChanged' },
  }
})

vim.diagnostic.config({ virtual_text = false }) -- disable built-in virtual text diagnostics
