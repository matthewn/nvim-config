require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        -- make C-j and C-k function in 'results' box insert mode
        ['<C-j>'] = require('telescope.actions').move_selection_next,
        ['<C-k>'] = require('telescope.actions').move_selection_previous,
      },
    },
  },
}

local keymap = vim.keymap.set
keymap('n', '<leader>m', '<cmd>Telescope oldfiles<cr>', { silent = true })
keymap('n', '<leader>f', '<cmd>Telescope git_files<cr>', { silent = true })
keymap('n', '<leader>F', '<cmd>Telescope find_files<cr>', { silent = true })
keymap('n', '<leader>b', '<cmd>Telescope buffers<cr>', { silent = true })
keymap('n', '<leader>g', '<cmd>Telescope live_grep<cr>', { silent = true })
keymap('n', '<leader>t', '<cmd>Telescope tags<cr>', { silent = true })
keymap('n', '<leader>T', '<cmd>Telescope lsp_document_symbols<cr>', { silent = true })
keymap('n', '<leader>r', '<cmd>Telescope registers<cr>', { silent = true })

