local M = {}
local ns_id = vim.api.nvim_create_namespace("color_tweak_previews")
local original_cache = {}
local all_lines_cache = {}

vim.fn.sign_define("TweakChanged", { text = "▎", texthl = "DiffAdd" })

local function get_hex(color)
  if not color or color == -1 or color == "NONE" then return "NONE" end
  return string.format("#%06x", color)
end

local function format_line(name, fg, bg, bold, italic, link)
  local display_name = name
  if #display_name > 30 then
    display_name = display_name:sub(1, 29) .. "…"
  end

  -- Col 1: Name (30) | Col 2: Sample Space (20)
  -- Total prefix length = 50 characters exactly.
  local prefix = string.format("%-30s                    ", display_name)

  -- Col 3: Starts at index 51. No leading spaces in the strings below.
  if link then
    return prefix .. "link:" .. link
  end

  local attrs = (bold and "bold " or "") .. (italic and "italic" or "")
  if attrs == "" then attrs = "plain" end
  return string.format("%sattr:%-15s fg:%-10s bg:%s", prefix, attrs, fg, bg)
end

local function get_group_from_line(line)
  local name = line:match("^(%S+)")
  if not name then return nil end
  if name:find("…$") then
    local pattern = name:sub(1, -4)
    for real_name, _ in pairs(original_cache) do
      if real_name:sub(1, #pattern) == pattern then return real_name end
    end
  end
  return name
end

local function is_line_changed(line)
  local name = get_group_from_line(line)
  local orig = original_cache[name]
  if not orig then return false end

  local link = line:match("link:(%S+)")
  if link then return link ~= orig.link end

  local attr, fg, bg = line:match("attr:(%S+)%s+fg:(%S+)%s+bg:(%S+)")
  if not attr then return false end

  return fg ~= orig.fg or bg ~= orig.bg or
         (attr:find("bold") ~= nil) ~= (orig.bold == true) or
         (attr:find("italic") ~= nil) ~= (orig.italic == true)
end

local function refresh_all_previews(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, line in ipairs(lines) do
    local group = get_group_from_line(line)
    if group then
      local extmark_id = i
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      local fg, bg = get_hex(hl.fg), get_hex(hl.bg)

      if fg ~= "NONE" or bg ~= "NONE" or hl.bold or hl.italic then
        local preview_hl = "TweakPrev_" .. group:gsub("[^%w_]", "_")
        vim.api.nvim_set_hl(0, preview_hl, {
          fg = (fg ~= "NONE" and fg or nil),
          bg = (bg ~= "NONE" and bg or nil),
          bold = hl.bold,
          italic = hl.italic
        })
        -- Overlay exactly where the 20 spaces are (starts at col 30)
        pcall(vim.api.nvim_buf_set_extmark, buf, ns_id, i - 1, 30, {
          id = extmark_id,
          virt_text = { { "  Sample Text  ", preview_hl } },
          virt_text_pos = "overlay"
        })
      else
        vim.api.nvim_buf_del_extmark(buf, ns_id, extmark_id)
      end
    end
  end
end

function M.apply_line_change(line)
  if not line then return nil end
  local group = get_group_from_line(line)
  local link_target = line:match("link:(%S+)")
  local attr, fg, bg = line:match("attr:(%S+)%s+fg:(%S+)%s+bg:(%S+)")

  local opts = { force = true }
  if link_target then
    opts.link = link_target
  elseif group and attr then
    opts.fg = (fg ~= "NONE") and fg or nil
    opts.bg = (bg ~= "NONE") and bg or nil
    opts.bold = (attr and attr:find("bold") ~= nil)
    opts.italic = (attr and attr:find("italic") ~= nil)
  else return nil end

  pcall(vim.api.nvim_set_hl, 0, group, opts)
  if group == "Normal" then vim.cmd("redraw") end
  return group
end

function M.open_tweak_buffer()
  local base_theme = vim.g.colors_name or "default"
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(b):find("Tweak-" .. base_theme) then
      vim.api.nvim_set_current_buf(b)
      return
    end
  end

  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, "Tweak-" .. base_theme)
  vim.bo[buf].buftype, vim.bo[buf].bufhidden, vim.bo[buf].buflisted = "nofile", "hide", true
  vim.bo[buf].modifiable, vim.bo[buf].filetype = true, "colortweak"
  vim.wo.signcolumn = "yes"

  local hl_groups = vim.fn.getcompletion('', 'highlight')
  all_lines_cache, original_cache = {}, {}

  local function process_group(name)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = true })
    if hl.link or hl.fg or hl.bg or hl.bold or hl.italic then
      local entry = { fg = get_hex(hl.fg), bg = get_hex(hl.bg), link = hl.link, bold = hl.bold, italic = hl.italic }
      original_cache[name] = entry
      table.insert(all_lines_cache, format_line(name, entry.fg, entry.bg, entry.bold, entry.italic, entry.link))
    end
  end

  process_group("Normal")
  for _, name in ipairs(hl_groups) do
    if name ~= "Normal" then process_group(name) end
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, all_lines_cache)
  vim.api.nvim_set_current_buf(buf)
  refresh_all_previews(buf)

  local opts = { buffer = buf, silent = true }
  vim.keymap.set('n', 'q', ':bw<CR>', opts)
  vim.keymap.set('n', 'g/', function() M.filter_buffer(buf) end, opts)
  vim.keymap.set('n', 'U', function() M.reset_current_line(buf) end, opts)
  vim.keymap.set('n', 'gf', function() M.follow_link(buf) end, opts)
  vim.keymap.set('n', 'go', function() M.generate_output(base_theme, buf) end, opts)

  vim.api.nvim_buf_attach(buf, false, {
    on_lines = function(_, b, _, _, _, _)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(b) then return end
        local lines = vim.api.nvim_buf_get_lines(b, 0, -1, false)
        for _, line in ipairs(lines) do M.apply_line_change(line) end
        refresh_all_previews(b)

        local qf_list = {}
        vim.fn.sign_unplace("TweakSigns", { buffer = b })
        for idx, l in ipairs(lines) do
          if is_line_changed(l) then
            vim.fn.sign_place(0, "TweakSigns", "TweakChanged", b, { lnum = idx, priority = 10 })
            table.insert(qf_list, { bufnr = b, lnum = idx, text = "MOD: " .. (get_group_from_line(l) or ""), type = 'W' })
          end
        end
        vim.fn.setloclist(0, qf_list, 'r')
      end)
    end
  })
end

function M.reset_current_line(buf)
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
  if not line then return end
  local group = get_group_from_line(line)
  local orig = original_cache[group]
  if orig then
    local new_line = format_line(group, orig.fg, orig.bg, orig.bold, orig.italic, orig.link)
    vim.api.nvim_buf_set_lines(buf, row, row + 1, false, {new_line})
  end
end

function M.filter_buffer(buf)
  vim.ui.input({ prompt = "Filter (<cr> to reset): " }, function(input)
    if not input then return end
    local filtered = {}
    for _, l in ipairs(all_lines_cache) do
      if input == "" or l:lower():find(input:lower()) then table.insert(filtered, l) end
    end
    vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, filtered)
    refresh_all_previews(buf)
  end)
end

function M.generate_output(base_theme, buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local output = { "-- tweaks for " .. base_theme, "vim.cmd('colorscheme " .. base_theme .. "')", "local hl = vim.api.nvim_set_hl", "" }
  local changes_found = false
  for _, line in ipairs(lines) do
    if is_line_changed(line) then
      changes_found = true
      local group = get_group_from_line(line)
      local link = line:match("link:(%S+)")
      local attr, fg, bg = line:match("attr:(%S+)%s+fg:(%S+)%s+bg:(%S+)")
      if link then table.insert(output, string.format("hl(0, '%s', { link = '%s' })", group, link))
      else
        local p = {}
        if fg ~= "NONE" then table.insert(p, "fg = '"..fg.."'") end
        if bg ~= "NONE" then table.insert(p, "bg = '"..bg.."'") end
        if attr:find("bold") then table.insert(p, "bold = true") end
        if attr:find("italic") then table.insert(p, "italic = true") end
        table.insert(output, string.format("hl(0, '%s', { %s })", group, table.concat(p, ", ")))
      end
    end
  end
  if not changes_found then print("No changes detected!") return end
  local out_buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, output)
  vim.api.nvim_set_current_buf(out_buf)
  vim.bo[out_buf].filetype = "lua"
end

function M.follow_link(buf)
  local line = vim.api.nvim_get_current_line()
  local target = line:match("link:(%S+)")
  if not target then return end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, l in ipairs(lines) do
    if get_group_from_line(l) == target then
      vim.api.nvim_win_set_cursor(0, {i, 0})
      return
    end
  end
end

vim.api.nvim_create_user_command("ColorSchemeTweak", M.open_tweak_buffer, {})
return M
