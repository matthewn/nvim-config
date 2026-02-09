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
