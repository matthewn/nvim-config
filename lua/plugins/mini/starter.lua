---@diagnostic disable: undefined-field

-- mini.starter: start screen (replaces vim-startify)
-- NOTE: depends on mini.sessions being set up (see plugins/mini/sessions.lua) for `_G.MiniSessions`
local starter = require('mini.starter')
local fortunes = require('fortunes')

-- sessions section: 'init' session pinned first, rest alphabetical
local function sessions_section()
  return function()
    local names = {}
    for name in pairs(_G.MiniSessions.detected) do
      if name ~= '__LAST__' then -- skip startify's leftover "last session" symlink
        names[#names + 1] = name
      end
    end
    table.sort(names, function(a, b)
      if a == 'init' then return true end
      if b == 'init' then return false end
      return a < b
    end)

    if #names == 0 then
      return { { name = 'There are no sessions', action = '', section = 'Sessions' } }
    end

    local items = {}
    for _, name in ipairs(names) do
      items[#items + 1] = {
        name = name,
        action = function() _G.MiniSessions.read(name) end,
        section = 'Sessions',
      }
    end
    return items
  end
end

local function bookmarks_section()
  return {
    -- `shortcut = 'c'` overrides the default first-letter key, freeing 'b' for balboa
    { name = 'bashrc (~/.bashrc)', action = 'edit ~/.bashrc', section = 'Bookmarks', shortcut = 'c' },
    -- { name = 'gtkrc (~/.gtkrc)', action = 'edit ~/.gtkrc', section = 'Bookmarks' },
  }
end

-- word-wrap a line to `width` display columns, returning a list of lines
local function wrap(line, width)
  if line == '' then return { '' } end
  local out, cur = {}, ''
  for word in line:gmatch('%S+') do
    if cur == '' then
      cur = word
    elseif vim.fn.strdisplaywidth(cur .. ' ' .. word) <= width then
      cur = cur .. ' ' .. word
    else
      out[#out + 1] = cur
      cur = word
    end
  end
  out[#out + 1] = cur
  return out
end

local session_quote = fortunes.random()

-- an ASCII goat beneath the quote, in startify's cowsay style (backslashes escaped)
local goat = {
  '       o',
  '        o   \\^^/',
  '         o  (oo)\\_______',
  '            (__)\\       )\\/\\',
  '             \\/ ||----w |',
  '                ||     ||',
}

-- draw the session's fortune inside a unicode box, cow beneath (startify's
-- boxed-cowsay style)
local function boxed_fortune()
  local lines = {}
  for _, l in ipairs(session_quote) do
    vim.list_extend(lines, wrap(l, 50))
  end
  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  local boxed = { '╭' .. string.rep('─', width + 2) .. '╮' }
  for _, l in ipairs(lines) do
    local pad = string.rep(' ', width - vim.fn.strdisplaywidth(l))
    boxed[#boxed + 1] = '│ ' .. l .. pad .. ' │'
  end
  boxed[#boxed + 1] = '╰' .. string.rep('─', width + 2) .. '╯'
  vim.list_extend(boxed, goat)
  return table.concat(boxed, '\n')
end

local key_ns = vim.api.nvim_create_namespace('mini_starter_keys')

-- We highlight a single (possibly non-leading) key letter ourselves, so hide
-- mini's built-in leading-prefix highlight and define our own key colour.
-- Re-applied on ColorScheme since mini resets MiniStarterItemPrefix there.
local function set_starter_hl()
  vim.api.nvim_set_hl(0, 'MiniStarterItemPrefix', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'MiniStarterKey', { link = 'WarningMsg' })
end
set_starter_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_starter_hl, desc = 'mini.starter key highlight' })

-- Assign a one-key shortcut for `name`: use `pref` if given and free, else the
-- first free letter of the basename, else any free letter. Returns the key and
-- the 0-based offset of that letter within `name` (nil if not present).
local function assign(name, used, pref)
  if pref and not used[pref] then
    used[pref] = true
    for i = 1, #name do
      if name:sub(i, i):lower() == pref then return pref, i - 1 end
    end
    return pref, nil
  end
  local base = name:match('^%S+') or name
  for i = 1, #base do
    local ch = base:sub(i, i):lower()
    if ch:match('%a') and not used[ch] then
      used[ch] = true
      return ch, i - 1
    end
  end
  for k = 0, 25 do
    local ch = string.char(97 + k)
    if not used[ch] then
      used[ch] = true
      return ch
    end
  end
end

local RESERVED_SECTIONS = { ['Bookmarks'] = true, ['Builtin actions'] = true }

-- Give each selectable item a unique one-key shortcut derived from its name:
-- highlight that letter and map it so the item is one keypress away.
local function apply_starter_keys(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= 'ministarter' then
    return
  end
  local items = starter.content_to_items(starter.get_content(buf))
  local used, plan = {}, {}
  local function add(item, pref)
    if item.action == '' then return end
    local key, offset = assign(item.name, used, pref)
    plan[#plan + 1] = { item = item, key = key, offset = offset }
  end

  -- reserve fixed keys first (first letter, or an explicit `shortcut`) so
  -- sessions/MRU pick around them
  for _, item in ipairs(items) do
    if RESERVED_SECTIONS[item.section] then add(item, item.shortcut or item.name:sub(1, 1):lower()) end
  end
  for _, item in ipairs(items) do
    if not RESERVED_SECTIONS[item.section] then add(item) end
  end

  vim.api.nvim_buf_clear_namespace(buf, key_ns, 0, -1)
  for _, p in ipairs(plan) do
    if p.offset then
      vim.api.nvim_buf_set_extmark(buf, key_ns, p.item._line, p.item._start_col + p.offset, {
        end_col = p.item._start_col + p.offset + 1, hl_group = 'MiniStarterKey', priority = 200,
      })
    end
    local action = p.item.action
    vim.keymap.set('n', p.key, function()
      if type(action) == 'function' then action() else vim.cmd(action) end
    end, { buffer = buf, nowait = true, desc = 'Start screen: ' .. p.item.name })
  end

  -- park the block cursor in the left margin so it never covers a key highlight
  -- (mini repositions to each item's `_cursorpos` on CursorMoved, so override it)
  for _, item in ipairs(items) do
    item._cursorpos = { item._line + 1, 0 }
  end
  pcall(vim.api.nvim_win_set_cursor, 0, { vim.api.nvim_win_get_cursor(0)[1], 0 })
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniStarterOpened',
  callback = function(args)
    local buf = args.buf
    apply_starter_keys(buf)
    -- mini refreshes (and clears our extmarks) on VimResized/BufEnter -- notably
    -- when neovide applies its startup font/size. Re-apply after those. Defined
    -- here so it runs *after* mini's own refresh autocmd (created in open()).
    local grp = vim.api.nvim_create_augroup('MiniStarterKeys', { clear = false })
    vim.api.nvim_clear_autocmds({ group = grp, buffer = buf })
    vim.api.nvim_create_autocmd({ 'VimResized', 'BufEnter' }, {
      group = grp,
      buffer = buf,
      callback = function() apply_starter_keys(buf) end,
      desc = 'Re-apply start-screen key highlights after refresh',
    })
  end,
})

-- Layout hook: drop the (top) 'Builtin actions' section header, and add a blank
-- line after each remaining section header.
local function tweak_layout(content)
  local out = {}
  for _, line in ipairs(content) do
    local is_section = line[1] ~= nil and line[1].type == 'section'
    if is_section and line[1].string == 'Builtin actions' then
      -- builtins sit at the top with no header: drop this line
    else
      out[#out + 1] = line
      if is_section then
        out[#out + 1] = { { string = '', type = 'empty', hl = nil } }
      end
    end
  end
  return out
end

starter.setup({
  evaluate_single = true, -- a unique one-key match fires immediately (startify-style)
  items = {
    -- builtins on top (header dropped by tweak_layout); lowercased so 'e'/'q' read lower
    { name = 'edit new buffer', action = 'enew', section = 'Builtin actions' },
    { name = 'quit Neovim', action = 'qall', section = 'Builtin actions' },
    sessions_section(),
    starter.sections.recent_files(5, false),
    bookmarks_section(),
  },
  header = boxed_fortune,
  footer = '',
  content_hooks = {
    -- names render plain; one-key shortcuts are highlighted/mapped post-render
    -- by the MiniStarterOpened handler above
    tweak_layout,
    starter.gen_hook.padding(3, 2),
  },
})

-- open the start screen on demand
vim.keymap.set('n', '<leader><esc>', function()
  require('mini.starter').open()
end, { desc = 'Open mini.starter' })
