vim.g.mapleader = ','

local keymap = vim.keymap.set

-- make up and down arrows NOT linewise in insert mode
keymap('i', '<Up>', '<C-\\><C-o>gk', { desc = 'Move up (display line)' })
keymap('i', '<Down>', '<C-\\><C-o>gj', { desc = 'Move down (display line)' })

-- mswin-style cut/copy/paste
keymap('v', '<C-c>', '"+y', { desc = 'Copy to clipboard' })
keymap('n', '<C-c>', '"+y$', { desc = 'Copy line to clipboard' })
keymap('v', '<C-x>', '"+d', { desc = 'Cut to clipboard' })
keymap('n', '<C-x>', '"+d$', { desc = 'Cut line to clipboard' })
keymap({'n', 'v'}, '<C-v>', '"+p', { desc = 'Paste from clipboard' })
keymap('i', '<C-v>', '<Esc>"+pa', { desc = 'Paste from clipboard (insert mode)' })
keymap('c', '<C-v>', '<C-r>+', { desc = 'Paste from clipboard (command-line mode)'})

-- <c-Q> for what <c-V> used to do (blockwise visual mode)
keymap('', '<C-q>', '<C-v>', { desc = 'Visual block mode (remapped from Ctrl-V)' })

-- avoid useless Ex mode, reassign Q to reflow/format
keymap('', 'Q', 'gq', { desc = 'Reflow/format text' })

-- reselect visual block after indent/outdent
keymap('v', '<', '<gv', { desc = 'Indent left and reselect' })
keymap('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- do not move cursor after yanking in visual mode
keymap('v', 'y', 'ygv<Esc>', { desc = 'Yank without moving cursor' })

-- switch to last active buffer with <leader>,
keymap('', '<leader>,', ':buffer #<cr>', { desc = 'Switch to previous buffer' })

-- <space> and - for additional pagedown/up
keymap('', '<Space>', '<PageDown>', { desc = 'Page down' })
keymap('', '-', '<PageUp>', { desc = 'Page up' })

-- easy escape
keymap('i', 'jj', '<esc>', { desc = 'Exit insert mode' })

-- warp speed omnicomplete: map ';;' to trigger in insert mode
keymap('i', ';;', '<C-x><C-o>', { desc = 'Trigger omnicompletion' })

-- ctrl-l fixes most recent misspelling in insert mode
keymap('i', '<C-l>', '<C-g>u<Esc>[s1z=`]a<C-g>u', { desc = 'Fix last spelling error' })

-- clear the search highlights
keymap('n', 'g<space>', ':nohlsearch<cr>', { silent = true, desc = 'Clear search highlights' })

-- toggle line wrap
keymap('n', '<leader>W', ':silent set wrap!<cr>:set wrap?<cr>', { silent = true, desc = 'Toggle line wrap' })

-- toggle line numbering
keymap('n', '<leader>#', ':silent set number!<cr>:set number?<cr>', { silent = true, desc = 'Toggle line numbers' })

-- fold tag
keymap('n', 'zT', 'Vatzf', { desc = 'Fold current HTML tag' })

-- shortcut to write current buffer
keymap('n', '<leader>w', ':w!<cr>', { desc = 'Write buffer (force)' })

-- <leader>% does :source %
keymap('n', '<leader>%', ':source %<cr>', { desc = 'Source current file' })

-- make moving between windows easier
keymap('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- edit new file, starting in same directory as current file [brilliant!]
keymap('', '<leader>e', ':e <C-R>=expand("%:p:h") . "/" <cr>', { desc = 'Edit file in current directory' })

-- tab stop changes
local function set_indent(width)
  vim.opt.tabstop = width
  vim.opt.softtabstop = width
  vim.opt.shiftwidth = width
  vim.cmd('set tabstop?')
end
keymap('n', '<leader>#2', function() set_indent(2) end, { desc = 'Set tab width to 2' })
keymap('n', '<leader>#4', function() set_indent(4) end, { desc = 'Set tab width to 4' })
keymap('n', '<leader>#8', function() set_indent(8) end, { desc = 'Set tab width to 8' })

-- toggle cursorcolumn
keymap('n', '<leader>L', ':execute "setlocal colorcolumn=" . (&colorcolumn == "" ? "80" : "")<cr>', {
  silent = true,
  desc = 'Toggle 80-column marker'
})

-- search for the current visual selection with // (!!!)
keymap('v', '//', [[y/\V<C-R>=escape(@",'/\')<cr><cr>]], { desc = 'Search for selected text' })

-- html input mappings
keymap('', '<leader>a', 'gewi<a href=""><esc>ea</a><esc>F>hi', { desc = 'Wrap word in anchor tag' })
keymap('v', '<leader>a', 'di<a href=""<esc>mza><esc>pa</a><esc>`zi', { desc = 'Wrap selection in anchor tag' })

-- write with sudo, dammit
vim.cmd([[cmap w!! w !sudo tee % >/dev/null]])

-- bug out with gs ("get stuffed!") (this used to point at bufkill.vim's :BD)
vim.keymap.set('n', 'gs', function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local buftype = vim.bo.buftype
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local specials = { 'help', 'quickfix', 'loclist', 'nofile' }
  local is_special =
    vim.tbl_contains(specials, buftype)
    or bufname:match('paq%.log$')
  local function is_real(win)
    return vim.fn.win_gettype(win) == ''
  end
  local real_wins = vim.tbl_filter(is_real, wins)

  if is_special and #real_wins > 1 then
    vim.cmd('quit')
  else
    if package.loaded['barbar'] then
      vim.cmd('confirm BufferClose') -- delete normal buffer, barbar-style
    else
      vim.cmd('bd') -- delete normal buffer
    end
  end
end, { silent = true, desc = 'Get stuffed!' })


-- mappings for plugins that don't have their own lua config files

-- bufonly
keymap('n', '<leader>o', ':BufOnly<cr>', { desc = 'Close all buffers except current' })

-- easyalign
keymap('v', '<cr>', '<plug>(EasyAlign)', { desc = 'Align selection' })

-- neogit
keymap('n', '<leader>G', ':Neogit<cr>', { desc = 'Open Neogit' })

-- sideways.vim
keymap('n', '<C-S-h>', ':SidewaysLeft<cr>', { desc = 'Move argument left' })
keymap('n', '<C-S-l>', ':SidewaysRight<cr>', { desc = 'Move argument right' })

-- startify
keymap('n', '<leader><esc>', ':Startify<cr>', { desc = 'Open Startify' })
keymap('n', '<leader>XX', ':SClose<cr>', { desc = 'Close session' })
keymap('n', '<leader>SS', ':SSave!<cr>', { desc = 'Save session' })

-- timemachine (gundo replacement)
keymap('n', '<leader>u', '<cmd>TimeMachineToggle<cr>', { desc = 'Toggle undo history' })
