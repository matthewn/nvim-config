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

-- :FreeKeys shows unused <leader><char> and g<char> combos
vim.api.nvim_create_user_command('FreeKeys', function()
  local used = {}

  -- escape for Lua pattern
  local function escape_char(c)
    return c:gsub('([%%%^%$%(%)%.%[%]%*%+%-%?])', '%%%1')
  end

  -- record used mappings for a prefix
  local function record(prefix)
    local maps = vim.api.nvim_get_keymap('n')
    if prefix == "<leader>" then
      local leader_char = vim.g.mapleader or '\\'
      local pleader = escape_char(leader_char)
      for _, m in ipairs(maps) do
        local key = m.lhs:match('^' .. pleader .. '(.?)$')
        if key then used[key] = true end
      end
    elseif prefix == "g" then
      for _, m in ipairs(maps) do
        local key = m.lhs:match('^g(.?)$')
        if key then used["g"..key] = true end
      end
    end
  end

  record("<leader>")
  record("g")

  -- collect unused combos for a prefix
  local function collect(prefix, groups)
    local t = {}
    for _, g in ipairs(groups) do
      if type(g) == "string" then
        for i = 1, #g do
          local k = g:sub(i,i)
          local check = prefix == "g" and prefix..k or k
          if not used[check] then table.insert(t, prefix..k) end
        end
      else -- range {from,to}
        for c = string.byte(g[1]), string.byte(g[2]) do
          local k = string.char(c)
          local check = prefix == "g" and prefix..k or k
          if not used[check] then table.insert(t, prefix..k) end
        end
      end
    end
    return t
  end

  local groups = {
    {'a','z'}, {'A','Z'}, {'0','9'},
    [[!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]
  }

  for _, prefix in ipairs({"<leader>", "g"}) do
    for _, k in ipairs(collect(prefix, groups)) do
      print(k)
    end
  end
end, {})
