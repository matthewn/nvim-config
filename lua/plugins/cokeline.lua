-- lua/plugins/cokeline.lua
local components = {
  -- devicon
  {
    text = function(buffer)
      return buffer.devicon.icon or ''
    end,
    hl = {
      fg = function(buffer)
        return buffer.devicon.color
      end,
    },
    truncation = { priority = 1 },
  },

  -- spacer
  {
    text = ' ',
  },

  -- filename
  {
    text = function(buffer)
      return buffer.filename
    end,
    hl = {
      style = function(buffer)
        return buffer.is_focused and 'bold' or nil
      end,
    },
    truncation = { priority = 2 },
  },

  -- modified indicator
  {
    text = function(buffer)
      return buffer.is_modified and '●' or ''
    end,
    hl = { fg = 'red', style = 'bold' },
  },

  -- no close button
}

require('cokeline').setup({
  components = components,
})

-- Neovide-only keymaps
if vim.g.neovide ~= nil then
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<C-Tab>', '<Plug>(cokeline-focus-next)', opts)
  vim.keymap.set('n', '<C-S-Tab>', '<Plug>(cokeline-focus-prev)', opts)
end
