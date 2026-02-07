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
    -- make find_files include files ignored by git
    find_files = {
      no_ignore = true,
    },
    -- make git_bcommits picker open old versions in temp/readonly buffers
    -- (rather than checking them out -- destructive!)
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
keymap('n', '<leader>f', '<cmd>Telescope git_files<cr>', { desc = 'Find git files' })
keymap('n', '<leader>F', '<cmd>Telescope find_files<cr>', { desc = 'Find all files' })
keymap('n', '<leader>m', '<cmd>Telescope oldfiles<cr>', { desc = 'Recent files (MRU)' })
keymap('n', '<leader>b', '<cmd>Telescope git_bcommits<cr>', { desc = 'Buffer git commits' })
keymap('n', '<leader>g', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep in project' })
keymap('n', '<leader>r', '<cmd>Telescope registers<cr>', { desc = 'View registers' })
keymap('n', '<leader>k', '<cmd>Telescope commands<cr>', { desc = 'Search commands' })
keymap('n', '<leader>K', '<cmd>Telescope keymaps<cr>', { desc = 'Search keymaps' })
keymap('n', '<leader>h', '<cmd>Telescope help_tags<cr>', { desc = 'Search help tags' })
keymap('n', '<leader>O', '<cmd>Telescope vim_options<cr>', { desc = 'Search vim options' })
