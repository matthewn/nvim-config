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
  pickers = {
    -- redefine the behavior of the git_bcommits picker:
    -- open old versions in temp/readonly buffers rather than checking them out
    git_bcommits = {
      attach_mappings = function(prompt_bufnr)
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')

        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          local commit = entry.value
          local file = vim.fn.expand('%')
          local buf = vim.api.nvim_create_buf(true, true)
          local ft = vim.bo.filetype
          local fname = vim.fn.fnamemodify(file, ':t')

          vim.bo[buf].buftype = 'nofile'
          vim.bo[buf].filetype = ft
          vim.bo[buf].modifiable = true

          vim.api.nvim_buf_set_name(buf, string.format('%s @ %s', fname, commit:sub(1,8)))
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.systemlist(string.format('git show %s:%s', commit, file)))

          vim.bo[buf].modifiable = false
          vim.bo[buf].readonly   = true

          vim.api.nvim_set_current_buf(buf)
        end)

        return true
      end,
    },
  }
}

local keymap = vim.keymap.set
keymap('n', '<leader>m', '<cmd>Telescope oldfiles<cr>', { silent = true })
keymap('n', '<leader>f', '<cmd>Telescope git_files<cr>', { silent = true })
keymap('n', '<leader>F', '<cmd>Telescope find_files<cr>', { silent = true })
keymap('n', '<leader>b', '<cmd>Telescope git_bcommits<cr>', { silent = true })
keymap('n', '<leader>g', '<cmd>Telescope live_grep<cr>', { silent = true })
keymap('n', '<leader>r', '<cmd>Telescope registers<cr>', { silent = true })
