local hl = vim.api.nvim_set_hl
local autocmd = vim.api.nvim_create_autocmd

-- re-enable custom highlights after loading a colorscheme
-- (see https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
--  for more on why this is where custom color changes should go)
local function my_highlights()
  -- set color for colorcolumn
  hl(0, 'ColorColumn', { ctermbg = 'red', bg = 'darkred' })

  -- DO NOT grey out lines with F841 (unused var) warning from pylsp
  hl(0, 'DiagnosticUnnecessary', {})

  -- todo-comments highlighting overrides
  hl(0, 'TodoBgFIX', { fg = '#eeeeee', bg = '#900d09' }) -- blackish/scarlet
  hl(0, 'TodoBgTODO', { fg = '#111111', bg = '#f8e473' }) -- whiteish/'laguna' yellow

  -- gitsigns: turn staged git hunk signs lime green
  local lime = '#00FF00'
  hl(0, 'GitSignsStagedAdd',    { fg = lime })
  hl(0, 'GitSignsStagedChange', { fg = lime })
  hl(0, 'GitSignsStagedDelete', { fg = lime })
  hl(0, 'GitSignsStagedAddNr',     { fg = lime })
  hl(0, 'GitSignsStagedAddLn',     { fg = lime })
  hl(0, 'GitSignsStagedChangeNr',  { fg = lime })
  hl(0, 'GitSignsStagedChangeLn',  { fg = lime })
  hl(0, 'GitSignsStagedDeleteNr',  { fg = lime })
  hl(0, 'GitSignsStagedDeleteLn',  { fg = lime })

  -- colorscheme-specific tweaks
  local colorscheme = vim.g.colors_name

  -- tweaks for neogotham
  if colorscheme == 'neogotham' then
    hl(0, 'MatchParen', { fg = '#ffffff', bg = '#0a3749' })
    hl(0, 'Search', { fg = '#ffffff', bg = '#245361' })
    -- hl(0, 'Pmenu', { fg = '#ffffff', bg = '#000066' })
    -- hl(0, 'pythonStatement', { fg = '#999999' })
  end

  -- tweaks for night-owl
  if colorscheme == 'night-owl' then
    hl(0, 'MatchParen', { fg = '#ffffff', bg = '#0a3749' })
    hl(0, 'Search', { fg = '#ffffff', bg = 'blue' })
    hl(0, 'IncSearch', { fg = '#ffffff', bg = 'blue' })
  end

  -- reinitialize the indent guides after all other color changes
  package.loaded['plugins.ibl-init'] = nil
  require('plugins.ibl-init')
end

-- set up autocommands
local my_colors_group = vim.api.nvim_create_augroup('MyColors', { clear = true })
autocmd('ColorScheme', {
  group = my_colors_group,
  callback = my_highlights,
})
autocmd('BufWinEnter', {
  group = my_colors_group,
  callback = my_highlights,
})
