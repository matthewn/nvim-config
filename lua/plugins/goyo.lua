vim.g.goyo_height = "90%"
local M = {}
M.active = false
M.prev_colorscheme = nil

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoEnter',
  callback = function()
    if M.active then
      return
    end
    M.active = true
    M.prev_colorscheme = vim.g.colors_name
    vim.cmd('Bigger')
    vim.cmd('Bigger')
    -- vim.cmd("colorscheme darkblue")
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoLeave',
  callback = function()
    if not M.active then
      return
    end
    M.active = false
    vim.cmd('Smaller')
    vim.cmd('Smaller')
    if M.prev_colorscheme then
      vim.cmd('colorscheme ' .. M.prev_colorscheme)
      M.prev_colorscheme = nil
    end
  end,
})
