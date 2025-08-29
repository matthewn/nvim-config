vim.g.mapleader = ','
local keymap = vim.keymap.set

-- make up and down arrows NOT linewise in insert mode
keymap('i', '<Up>', '<C-\\><C-o>gk')
keymap('i', '<Down>', '<C-\\><C-o>gj')

-- mswin-style cut/copy/paste
keymap('v', '<C-c>', '"+y', { desc = 'Copy to clipboard' })
keymap('n', '<C-c>', '"+y$', { desc = 'Copy line to clipboard' })
keymap('v', '<C-x>', '"+d', { desc = 'Cut to clipboard' })
keymap('n', '<C-x>', '"+d$', { desc = 'Cut line to clipboard' })
keymap({'n', 'v'}, '<C-v>', '"+p', { desc = 'Paste from clipboard' })
keymap('i', '<C-v>', '<Esc>"+pa', { desc = 'Paste from clipboard (insert mode)' })
keymap('c', '<C-v>', '<C-r>+', { desc = 'Paste from clipboard (command-line mode)'})

-- <c-Q> for what <c-V> used to do (blockwise visual mode)
keymap('', '<C-q>', '<C-v>')

-- avoid useless Ex mode, reassign Q to reflow/rewrap
keymap('', 'Q', 'gq')

-- reselect visual block after indent/outdent
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- do not move cursor after yanking in visual mode
keymap('v', 'y', 'ygv<Esc>')

-- switch to last active buffer with <leader>,
keymap('', '<leader>,', ':buffer #<cr>')

-- <space> and - for additional pagedown/up
keymap('', '<Space>', '<PageDown>')
keymap('', '-', '<PageUp>')

-- easy escape
keymap('i', 'jj', '<esc>')

-- warp speed omnicomplete: map ';;' to trigger in insert mode
keymap('i', ';;', '<C-x><C-o>')

-- ctrl-l fixes most recent misspelling in insert mode
keymap('i', '<C-l>', '<C-g>u<Esc>[s1z=`]a<C-g>u')

-- shortcut to init.vim/lua
keymap('n', '<leader>v', ':e $MYVIMRC<cr>')

-- clear the search highlights
keymap('n', 'g<space>', ':nohlsearch<cr>', { silent = true })

-- toggle line wrap
keymap('n', '<leader>W', ':silent set wrap!<cr>:set wrap?<cr>', { silent = true })

-- toggle line numbering
keymap('n', '<leader>#', ':silent set number!<cr>:set number?<cr>', { silent = true })

-- fold tag
keymap('n', '<leader>zT', 'Vatzf')

-- shortcut to write current buffer
keymap('n', '<leader>w', ':w!<cr>')

-- make moving between windows easier
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- edit new file, starting in same directory as current file [brilliant!]
keymap('', '<leader>e', ':e <C-R>=expand("%:p:h") . "/" <cr>')

-- tab stop changes
keymap('n', '<leader>#2', ':set tabstop=2<cr><esc>:set softtabstop=2<cr><esc>:set shiftwidth=2<cr>')
keymap('n', '<leader>#4', ':set tabstop=4<cr><esc>:set softtabstop=4<cr><esc>:set shiftwidth=4<cr>')
keymap('n', '<leader>#8', ':set tabstop=8<cr><esc>:set softtabstop=8<cr><esc>:set shiftwidth=4<cr>')

-- bug out with bd (this used to point at bufkill.vim's :BD)
vim.keymap.set('n', 'bd', function()
  local buftype = vim.bo.buftype
  if vim.tbl_contains({'help', 'quickfix', 'loclist'}, buftype) then
    vim.cmd('quit')  -- close special window & remove its buffer
  else
    if package.loaded['barbar'] then
      vim.cmd('BufferClose') -- delete normal buffer, barbar-style
    else
      vim.cmd('bd') -- delete normal buffer
    end
  end
end, { silent = true })

-- toggle cursorcolumn
keymap('n', '<leader>L', ':execute "setlocal colorcolumn=" . (&colorcolumn == "" ? "80" : "")<cr>', { silent = true })

-- search for the current visual selection with // (!!!)
keymap('v', '//', [[y/\V<C-R>=escape(@",'/\')<cr><cr>]])

-- html input mappings
keymap('', '<leader>a', 'gewi<a href=""><esc>ea</a><esc>F>hi')
keymap('v', '<leader>a', 'di<a href=""<esc>mza><esc>pa</a><esc>`zi')

-- write with sudo, dammit
vim.cmd([[cmap w!! w !sudo tee % >/dev/null]])


-- mappings for plugins

-- barbar: buffer next/previous
if vim.g.neovide then
  keymap('n', '<C-Tab>', '<Cmd>BufferNext<CR>', { silent = true })
  keymap('n', '<C-S-Tab>', '<Cmd>BufferPrevious<CR>', { silent = true })
end
keymap('n', 'gbn', '<Cmd>BufferNext<CR>', { silent = true })
keymap('n', 'gbp', '<Cmd>BufferPrevious<CR>', { silent = true })

-- bufonly
keymap('n', '<leader>o', ':BufOnly<cr>', { silent = true })

-- ctrlsf
keymap('n', '<leader>F', ':CtrlSF<space>', { silent = false })

-- easyalign
keymap('v', '<cr>', '<Plug>(EasyAlign)', {})

-- gitgutter toggle
keymap('n', '<leader>\\', ':GitGutterToggle<cr>', { silent = true })

-- sideways.vim
keymap('n', '<C-S-h>', ':SidewaysLeft<cr>', { silent = true })
keymap('n', '<C-S-l>', ':SidewaysRight<cr>', { silent = true })

-- startify
keymap('n', '<leader><esc>', ':Startify<cr>')
keymap('n', '<leader>sc', ':SClose<cr>', { silent = true })
keymap('n', '<leader>sd', ':SDelete ')
keymap('n', '<leader>so', ':SLoad ')
keymap('n', '<leader>ss', ':SSave!<cr>', { silent = true })

-- timemachine
keymap('n', '<leader>u', '<cmd>TimeMachineToggle<cr>', { silent = true })

