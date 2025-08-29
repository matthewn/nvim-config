if vim.g.neovide then

  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_scroll_animation_length = 0.05
  vim.opt.helpheight = 32

  vim.api.nvim_create_user_command('Bigger', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
  end, {})

  vim.api.nvim_create_user_command('Smaller', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
  end, {})

  vim.keymap.set('n', 'g=', ':Bigger<cr>', { desc = 'Increase font size' })
  vim.keymap.set('n', 'g-', ':Smaller<cr>', { desc = 'Decrease font size' })

end
