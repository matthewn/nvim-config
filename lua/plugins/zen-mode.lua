---@diagnostic disable: undefined-field

local zen = require('zen-mode')

-- enter dirs for auto zen-mode on next line
local target_dirs = { 'untethered' }
local pattern_list = {}
for _, dir in ipairs(target_dirs) do
  table.insert(pattern_list, '*/' .. dir .. '/*')
end

function _G.zen_word_count()
  local words = vim.fn.wordcount()
  local current = words.visual_words or words.cursor_words or 0
  return string.format('Word %d of %d', current, words.words or 0)
end

zen.setup({
  window = {
    width = 80,
    height = 0.96,
    options = { spell = true, linebreak = true },
  },
  plugins = {
    options = { enabled = true, laststatus = 3 },
    neovide = { enabled = true, scale = 1.2, fullscreen = true },
  },
  on_open = function()
    _G.zen_is_active = true

    vim.b.ministatusline_disable = true
    vim.api.nvim_set_hl(0, 'StatusLine', { fg = '#808080', bg = 'none' })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = '#808080', bg = 'none' })
    vim.opt.statusline = ' %{v:lua.zen_word_count()} %= %p%% '

    vim.cmd('hi! link NonText Normal')
    vim.cmd('hi! link SpecialKey Normal')

    vim.keymap.set('n', '<leader><space>', function()
      vim.opt.statusline = (vim.opt.statusline:get() == ' ')
        and ' %{v:lua.zen_word_count()} %= %p%% '
        or ' '
    end, { buffer = true, desc = 'Toggle zen statusline' })
  end,
  on_close = function()
    _G.zen_is_active = false
    vim.b.ministatusline_disable = false
    if _G.MiniStatusline then _G.MiniStatusline.setup() end
    if vim.g.colors_name then vim.cmd('colorscheme ' .. vim.g.colors_name) end
  end,
})

-- autocmd that triggers auto zen-mode
local group = vim.api.nvim_create_augroup('ZenAuto', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  pattern = pattern_list,
  callback = function()
    -- only trigger if we aren't already in zen and it's a valid file
    if not _G.zen_is_active and vim.bo.filetype ~= 'startify' and vim.api.nvim_buf_get_name(0) ~= '' then
      vim.schedule(zen.open)
    end
  end,
})
