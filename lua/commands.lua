-- resolve a highlight group name into its final concrete attributes
local function resolve_hl(name)
  local seen = {}
  local current = name
  while current and not seen[current] do
    seen[current] = true
    local hl = vim.api.nvim_get_hl(0, { name = current, link = true })
    if not hl then return current, {} end
    if hl.link then
      current = hl.link
    else
      return current, hl
    end
  end
  return name, {}
end

-- :HLGroup returns tree-sitter or syntax engine group under cursor
vim.api.nvim_create_user_command('HLGroup', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- TS uses 0-based row
  col = col

  local out = {}

  -- tree-sitter captures
  local ok_ts = pcall(function()
    return vim.treesitter.highlighter.active[bufnr]
  end)
  if ok_ts and vim.treesitter.highlighter.active[bufnr] then
    local captures = vim.treesitter.get_captures_at_pos(bufnr, row, col) or {}
    for _, cap in ipairs(captures) do
      local group = '@' .. cap.capture
      local final, attrs = resolve_hl(group)
      table.insert(out,
        string.format('TS: %-20s → %-20s %s', group, final, vim.inspect(attrs)))
    end
  end

  -- legacy syntax groups
  local line = vim.fn.line('.')
  local col1 = vim.fn.col('.') - 1
  local syn_id = vim.fn.synID(line, col1, 1)
  if syn_id > 0 then
    local syn_name = vim.fn.synIDattr(syn_id, 'name')
    local trans_name = vim.fn.synIDattr(vim.fn.synIDtrans(syn_id), 'name')
    local final, attrs = resolve_hl(trans_name)
    table.insert(out,
      string.format('Syntax: %-15s → %-15s → %-15s %s',
        syn_name, trans_name, final, vim.inspect(attrs)))
  end

  if #out == 0 then
    print('No highlight info')
  else
    print(table.concat(out, '\n'))
  end
end, {})

-- :LeaderFree shows unused <leader> combos
vim.api.nvim_create_user_command('LeaderFree', function()
  local leader = vim.g.mapleader or '\\'
  local used = {}
  local pleader = leader:gsub('([%%%^%$%(%)%.%[%]%*%+%-%?])', '%%%1')

  for _, m in ipairs(vim.api.nvim_get_keymap('n')) do
    local key = m.lhs:match('^' .. pleader .. '(.?)$')
    if key then used[key] = true end
  end

  local function collect(range)
    local t = {}
    for _, r in ipairs(range) do
      for c = string.byte(r[1]), string.byte(r[2]) do
        local k = string.char(c)
        if not used[k] then table.insert(t, '<leader>'..k) end
      end
    end
    return t
  end

  local lower = collect({{'a','z'}})
  local upper = collect({{'A','Z'}})
  local numbers = collect({{'0','9'}})

  local punct = {}
  for i = 1, #[[!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]] do
    local k = ([[!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]):sub(i,i)
    if not used[k] then table.insert(punct, '<leader>'..k) end
  end

  for _, k in ipairs(lower) do print(k) end
  for _, k in ipairs(upper) do print(k) end
  for _, k in ipairs(numbers) do print(k) end
  for _, k in ipairs(punct) do print(k) end
end, {})
