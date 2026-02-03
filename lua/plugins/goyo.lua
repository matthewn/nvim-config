vim.g.goyo_height = '90%'

-- auto-start Goyo for files in certain dirs (wherever they may be)
-- and auto-close Goyo when the last Goyo-eligible file is closed

local target_dirs = { 'untethered' }
local pattern_list = {}
local goyo_count = 0
local group = vim.api.nvim_create_augroup('GoyoAuto', { clear = true })
for _, dir in ipairs(target_dirs) do
    table.insert(pattern_list, '*/' .. dir .. '/*')
end

vim.api.nvim_create_autocmd('BufReadPost', {
    group = group,
    pattern = pattern_list,
    callback = function()
        goyo_count = goyo_count + 1
        if goyo_count == 1 then
            vim.cmd('Goyo')
        end
    end,
})

vim.api.nvim_create_autocmd('BufDelete', {
    group = group,
    pattern = pattern_list,
    callback = function()
        goyo_count = math.max(0, goyo_count - 1)
        if goyo_count == 0 then
            vim.cmd('Goyo')
        end
    end,
})

-- customize the Goyo environment
-- (GoyoEnter and GoyoLeave callbacks)

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
