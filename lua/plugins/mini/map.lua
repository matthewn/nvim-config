-- mini.map: scrollbars + minimap
local minimap = require('mini.map')

minimap.setup({
  integrations = {
    require('mini.map').gen_integration.builtin_search(),
    require('mini.map').gen_integration.gitsigns(),
    require('mini.map').gen_integration.diagnostic({
      error = 'DiagnosticFloatingError',
      warn  = 'DiagnosticFloatingWarn',
      info  = 'DiagnosticFloatingInfo',
      hint  = 'DiagnosticFloatingHint',
    }),
  },
  symbols = {
    encode = require('mini.map').gen_encode_symbols.dot('4x2'),
    scroll_line = '█',
    scroll_view = '┃',
  },
  window = { show_integration_count = false, width = 1 }
})

-- auto-open width-1 map (scrollbar only) on most buffers
local mapgroup = vim.api.nvim_create_augroup('mini.map', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = mapgroup,
  callback = function(args)
    local buftype = vim.bo[args.buf].buftype
    local filetype = vim.bo[args.buf].filetype
    -- skip special buffers; only apply to regular buffers
    if buftype == '' and filetype ~= '' then
      require('mini.map').open()
    end
  end,
})

-- helper: get minimap window width
local function get_minimap_width()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'minimap' then
      return vim.api.nvim_win_get_width(win)
    end
  end
  return nil -- minimap window not found
end

-- keymap to toggle minimap width
vim.keymap.set('n', '<leader>M', function()
  local width = get_minimap_width()
  -- fallback to configured width if minimap not open
  width = width or minimap.config.window.width
  if width == 1 then
    minimap.open({ window = { width = 12 } })
  else
    minimap.open({ window = { width = 1 } })
  end
end, { desc = 'Toggle minimap width' })
