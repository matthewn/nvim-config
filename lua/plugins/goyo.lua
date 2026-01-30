vim.g.goyo_height = "90%"
local M = {}
M.active = false

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoEnter',
  callback = function()
    if M.active then return end
    M.active = true

    -- vim.cmd("colorscheme darkblue")
    if vim.g.neovide then
      vim.g.neovide_fullscreen = true
      vim.cmd('Bigger')
      vim.cmd('Bigger')
    end
    vim.opt_local.lbr = true
    vim.opt_local.spell = true

  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoLeave',
  callback = function()
    if not M.active then return end
    M.active = false

    if vim.g.neovide then
      vim.g.neovide_fullscreen = false
      vim.cmd('Smaller')
      vim.cmd('Smaller')
    end
    vim.opt_local.lbr = false
    vim.opt_local.spell = false
  end,
})
