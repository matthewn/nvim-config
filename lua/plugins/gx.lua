require('gx').setup()
vim.g.netrw_nogx = 1 -- disable netrw gx
vim.keymap.set({'n', 'x'}, 'gx', '<cmd>Browse<cr>', { noremap = true, silent = true })
