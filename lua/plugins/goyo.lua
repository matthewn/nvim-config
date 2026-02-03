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
    if goyo_count >= 1 and not _G.goyo_is_launching then
      vim.schedule(function()
        if not _G.goyo_is_launching then
          vim.cmd('Goyo')
        end
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('BufDelete', {
  group = group,
  pattern = pattern_list,
  callback = function()
    goyo_count = math.max(0, goyo_count - 1)
    if goyo_count == 0 and _G.goyo_is_launching then
      vim.cmd('Goyo')
    end
  end,
})

-- customize the Goyo environment
-- (includes GoyoEnter and GoyoLeave callbacks)

local M = {}
M.is_active = false
_G.goyo_is_launching = false
M.show_status = true

function _G.goyo_word_count()
  local words = vim.fn.wordcount()
  local current = words.visual_words or words.cursor_words or 0
  return string.format('Word %d of %d', current, words.words or 0)
end

function _G.toggle_goyo_statusline()
  if not M.is_active then return end
  M.show_status = not M.show_status
  if M.show_status then
    vim.opt.statusline = ' %{v:lua.goyo_word_count()} %= %p%% '
  else
    vim.opt.statusline = ' '
  end
  vim.cmd('redrawstatus')
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoEnter',
  callback = function()
    if M.is_active then return end

    -- ENGAGE LOCK IMMEDIATELY
    _G.goyo_is_launching = true

    -- use vim.schedule to prevent edge case where Startify gets Goyo-ed
    vim.schedule(function()
      if vim.bo.filetype == 'startify' or vim.api.nvim_buf_get_name(0) == '' then
        _G.goyo_is_launching = false -- RELEASE LOCK ON ABORT
        if vim.g.goyo_linnr then vim.cmd('Goyo!') end
        return
      end

      M.is_active = true
      M.show_status = true

      -- statusline stuff
      vim.g.goyo_height = '97%'
      vim.b.ministatusline_disable = true
      vim.opt.laststatus = 3
      vim.opt.statusline = ' %{v:lua.goyo_word_count()} %= %p%% '
      vim.cmd([[
        hi WinSeparator guifg=bg guibg=bg
        hi StatusLine guifg=gray guibg=NONE gui=none
        hi StatusLineNC guifg=bg guibg=bg gui=none
      ]])
      vim.cmd('redraw!')
      vim.keymap.set(
        'n',
        '<leader><space>',
        '<cmd>lua toggle_goyo_statusline()<cr>',
        { buffer = true, desc = 'Toggle Goyo Statusline' }
      )

      if vim.g.neovide then
        M.original_scale = vim.g.neovide_scale_factor
        vim.g.neovide_scale_factor = 1.2
        vim.g.neovide_fullscreen = true
      end

      vim.opt_local.lbr = true
      vim.opt_local.spell = true
    end)
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'GoyoLeave',
  callback = function()
    if not M.is_active then return end
    M.is_active = false
    _G.goyo_is_launching = false

    -- clean up statusline changes
    vim.b.ministatusline_disable = false
    vim.opt.laststatus = 3
    vim.opt.statusline = nil
    vim.cmd([[
      hi clear WinSeparator
      hi clear StatusLine
      hi clear StatusLineNC
    ]])
    pcall(vim.keymap.del, 'n', '<leader><space>', { buffer = true })

    if vim.g.neovide then
      vim.g.neovide_scale_factor = M.original_scale or 1.0
      vim.g.neovide_fullscreen = false
    end

    vim.opt_local.lbr = false
    vim.opt_local.spell = false
  end,
})
