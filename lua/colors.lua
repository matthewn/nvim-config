local hl = vim.api.nvim_set_hl
local autocmd = vim.api.nvim_create_autocmd

-- re-enable custom highlights after loading a colorscheme
-- (see https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
--  for more on why this is where custom color changes should go)
local function my_highlights()
  -- set color for colorcolumn
  hl(0, 'ColorColumn', { ctermbg = 'red', bg = 'darkred' })

  local colorscheme = vim.g.colors_name

  -- tweaks for neogotham
  if colorscheme == 'neogotham' then
    hl(0, 'Comment', { fg = '#22738c' })
    hl(0, 'MatchParen', { fg = '#ffffff', bg = '#0a3749' })
    hl(0, 'Search', { fg = '#ffffff', bg = '#245361' })
    hl(0, 'Pmenu', { fg = '#ffffff', bg = '#000066' })
    hl(0, 'pythonStatement', { fg = '#999999' })
  end

  -- tweaks for night-owl
  if colorscheme == 'night-owl' then
    hl(0, 'MatchParen', { fg = '#ffffff', bg = '#0a3749' })
    hl(0, 'Search', { fg = '#ffffff', bg = 'blue' })
    hl(0, 'IncSearch', { fg = '#ffffff', bg = 'blue' })
    hl(0, 'Todo', { fg = '#ffffff', bg = 'red' })
  end

  -- tweaks for iceberg
  if colorscheme == 'iceberg' then
    if vim.o.background == 'light' then
      hl(0, 'TabLineSel', {
        ctermbg = 234,
        ctermfg = 252,
        gui = { bold = false },
        bg = '#cad0de',
        fg = '#3f83a6'
      })
    else
      hl(0, 'TabLineSel', {
        ctermbg = 234,
        ctermfg = 252,
        gui = { bold = false },
        bg = '#161821',
        fg = '#84a0c6'
      })
    end
  end

  -- reinitialize the indent guides
  package.loaded['plugins.ibl-init'] = nil
  require('plugins.ibl-init')
end

-- create autocommand group
local my_colors_group = vim.api.nvim_create_augroup('MyColors', { clear = true })

-- set up autocommands
autocmd('ColorScheme', {
  group = my_colors_group,
  callback = my_highlights,
})

autocmd('BufWinEnter', {
  group = my_colors_group,
  callback = my_highlights,
})
