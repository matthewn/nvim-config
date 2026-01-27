vim.g.goyo_height = "90%"
local M = {}
M.active = false

local augroup = vim.api.nvim_create_augroup('goyo', { clear = true })

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoEnter',
  group = augroup,
  callback = function()
    if M.active then return end
    M.active = true

    -- vim.cmd("colorscheme darkblue")
    vim.g.neovide_fullscreen = true
    vim.cmd('Bigger')
    vim.cmd('Bigger')
    vim.opt_local.lbr = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoLeave',
  group = augroup,
  callback = function()
    if not M.active then return end
    M.active = false

    vim.g.neovide_fullscreen = false
    vim.cmd('Smaller')
    vim.cmd('Smaller')
    vim.opt_local.lbr = false
    vim.opt_local.spell = false
  end,
})
