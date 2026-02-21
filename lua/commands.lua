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
  -- hardcoded list of built-ins that Neovim's API often fails to report.
  local builtins = {
    -- g prefix
    ["ga"]=1, ["g8"]=1, ["g_"]=1, ["g$"]=1, ["g%"]=1, ["g^"]=1, ["g,"]=1, ["g;"]=1,
    ["g<"]=1, ["g?"]=1, ["gD"]=1, ["gE"]=1, ["gH"]=1, ["gI"]=1, ["gJ"]=1, ["gN"]=1, ["gP"]=1,
    ["gQ"]=1, ["gR"]=1, ["gT"]=1, ["gU"]=1, ["gV"]=1, ["gW"]=1, ["gX"]=1, ["gZ"]=1, ["g]"]=1,
    ["gd"]=1, ["ge"]=1, ["gf"]=1, ["gF"]=1, ["gg"]=1, ["gh"]=1, ["gi"]=1,
    ["gj"]=1, ["gk"]=1, ["gl"]=1, ["gm"]=1, ["gn"]=1, ["go"]=1, ["gp"]=1, ["gq"]=1, ["gr"]=1,
    ["gs"]=1, ["gt"]=1, ["gu"]=1, ["gv"]=1, ["gw"]=1, ["gx"]=1, ["gy"]=1, ["gz"]=1, ["g&"]=1,
    -- [ and ] prefixes (diff jumps, section jumps, etc.)
    ["[c"]=1, ["]c"]=1, ["[d"]=1, ["]d"]=1, ["[D"]=1, ["]D"]=1, ["[i"]=1, ["]i"]=1,
    ["[I"]=1, ["]I"]=1, ["[#"]=1, ["]#"]=1, ["[("]=1, ["]("]=1, ["[z"]=1, ["]z"]=1,
    ["[{"]=1, ["]{"]=1, ["[m"]=1, ["]m"]=1, ["[M"]=1, ["]M"]=1, ["[["]=1, ["]]"]=1,
    ["[]"]=1, ["]["]=1, ["[s"]=1, ["]s"]=1, ["[S"]=1, ["]S"]=1, ["[f"]=1, ["]f"]=1,
  }

  local function is_taken(key)
    if vim.fn.maparg(key, 'n') ~= "" then return true end
    if builtins[key] then return true end
    if vim.fn.empty(vim.fn.mapcheck(key, 'n')) == 0 then return true end
    return false
  end

  local function collect(prefix, groups)
    local t = {}
    local leader = vim.g.mapleader or "\\"
    for _, g in ipairs(groups) do
      local chars = {}
      if type(g) == "table" then
        for c = string.byte(g[1]), string.byte(g[2]) do table.insert(chars, string.char(c)) end
      else
        for i = 1, #g do table.insert(chars, g:sub(i, i)) end
      end
      for _, char in ipairs(chars) do
        local display_key = prefix .. char
        local internal_key = (prefix == "<leader>") and (leader .. char) or (prefix .. char)
        if not is_taken(internal_key) then table.insert(t, display_key) end
      end
    end
    return t
  end

  local all_chars = {{'a', 'z'}, {'A', 'Z'}, {'0', '9'}, [[!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]}
  local letters_only = {{'a', 'z'}, {'A', 'Z'}}
  local config = {
    { p = "<leader>", g = all_chars },
    { p = "g",        g = all_chars },
    { p = "[",        g = letters_only },
    { p = "]",        g = letters_only }
  }

  local padding = 4
  local win_width = vim.o.columns - padding
  local wrap_at = win_width - 2
  local formatted_lines = {}

  for _, conf in ipairs(config) do
    local available = collect(conf.p, conf.g)
    if #available > 0 then
      table.insert(formatted_lines, "--- " .. conf.p .. " available ---")
      local current_line = ""
      for _, key in ipairs(available) do
        local entry = key .. "  "
        if #current_line + #entry > wrap_at then
          table.insert(formatted_lines, current_line)
          current_line = entry
        else
          current_line = current_line .. entry
        end
      end
      if current_line ~= "" then table.insert(formatted_lines, current_line) end
      table.insert(formatted_lines, "")
    end
  end

  if #formatted_lines == 0 then
    print("No free keys found!")
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_lines)
  local win_height = math.min(#formatted_lines, vim.o.lines - 4)

  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    col = (vim.o.columns - win_width) / 2,
    row = (vim.o.lines - win_height) / 2,
    style = 'minimal',
    border = 'rounded',
    title = ' Free Keys ',
    title_pos = 'center',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':q<CR>', { noremap = true, silent = true })
end, {})
