local themery = require('themery')

-- autodiscover all colorschemes
local all_schemes = vim.fn.getcompletion('', 'color')
local themes = {}
for _, name in ipairs(all_schemes) do
  table.insert(themes, {
    name = name,
    colorscheme = name,
  })
end

themery.setup({
  themes = themes,
  livePreview = true,
})
