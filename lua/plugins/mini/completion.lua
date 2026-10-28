-- mini.completion: lightweight, nearly setup-free completion that *behaves*
local completion = require('mini.completion')
completion.setup({
  delay = { completion = 200, info = 400, signature = 1200 },
  lsp_completion = {
    enabled = function()
      local ft = vim.bo.filetype
      if ft == 'html' or ft == 'htmldjango' or ft == 'markdown' then
        return false
      end
      return true
    end,
  },
  fallback_action = function()
    local ft = vim.bo.filetype
    if ft == 'markdown' then
      -- do nothing for markdown fallback
      return nil
    end
    -- default behavior for everything else (usually <C-n>)
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n', true)
  end,
})

-- smart tab functions (for keymaps below)
local function smart_tab()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes('<c-n>', true, true, true)
  end
  -- after a non-space char (e.g. `(` or a partial word), force LSP completion
  local col = vim.fn.col('.') - 1
  if col > 0 and vim.fn.getline('.'):sub(col, col):match('%S') then
    vim.schedule(completion.complete_twostage)
    return ''
  end
  return vim.api.nvim_replace_termcodes('<tab>', true, true, true)
end

local function smart_s_tab()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes('<c-p>', true, true, true)
  end
  return vim.api.nvim_replace_termcodes('<s-tab>', true, true, true)
end

vim.keymap.set('i', '<tab>', smart_tab, { expr = true, desc = 'Smart tab completion' })
vim.keymap.set('i', '<s-tab>', smart_s_tab, { expr = true, desc = 'Smart shift-tab completion' })
vim.keymap.set('i', '<cr>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', { expr = true, desc = 'Smart enter (accept completion)' })
