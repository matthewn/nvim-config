local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('init', { clear = true })

-- jump to last cursor location unless editing a git commit
autocmd('BufReadPost', {
  group = augroup,
  pattern = '*',
  desc = 'Jump to last cursor location unless editing a git commit',
  callback = function()
    local ft = vim.bo.filetype
    if not ft:match('^git') then
      local mark = vim.api.nvim_buf_get_mark(0, "'")
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end
  end,
})

-- close quickfix on <cr>
autocmd('FileType', {
  group = augroup,
  pattern = 'qf',
  desc = 'Close quickfix on <cr>',
  callback = function()
    vim.keymap.set('n', '<cr>', '<cr>:cclose<cr>', { buffer = true, silent = true })
  end,
})

-- ensure '-' is treated as a keyword character in CSS
autocmd('FileType', {
  group = augroup,
  pattern = 'css',
  desc = "Ensure '-' is treated as a keyword character in CSS",
  callback = function()
    vim.opt_local.iskeyword:append('-')
  end,
})
