vim.g.goyo_height = "90%"
local M = {}
M.active = false

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoEnter',
  callback = function()
    if M.active then return end
    M.active = true

    -- vim.cmd("colorscheme darkblue")
    vim.cmd('Bigger')
    vim.cmd('Bigger')
    vim.opt.lbr = true
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoLeave',
  callback = function()
    if not M.active then return end
    M.active = false

    vim.cmd('Smaller')
    vim.cmd('Smaller')
    vim.opt.lbr = false
  end,
})
