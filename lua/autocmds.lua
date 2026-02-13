local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('init', { clear = true })


autocmd('FileType', {
  desc = 'Enable treesitter on some filetypes',
  pattern = {'python', 'css', 'javascript', 'typescript', 'html', 'htmldjango', 'json'},
  group = augroup,
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    local has_parser = pcall(vim.treesitter.get_parser, args.buf, lang)
    if has_parser then
      vim.treesitter.start(args.buf, lang)
    else
      vim.notify(string.format("Treesitter parser [%s] missing. Run :TSInstall %s", lang, lang), vim.log.levels.WARN)
    end
  end,
})

autocmd('BufReadPost', {
  desc = 'Jump to last cursor location unless editing a git commit',
  pattern = '*',
  group = augroup,
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

autocmd('FileType', {
  desc = 'Neogit: keep focus on log when selecting a commit',
  pattern = 'NeogitCommitView',
  group = augroup,
  callback = function()
    vim.schedule(function()
      vim.cmd('wincmd p')
    end)
  end,
})

autocmd('FileType', {
  desc = 'Close quickfix on <cr>',
  pattern = 'qf',
  group = augroup,
  callback = function()
    vim.keymap.set('n', '<cr>', '<cr>:cclose<cr>', { buffer = true, silent = true })
  end,
})

autocmd('FileType', {
  desc = "Ensure '-' is treated as a keyword character in CSS",
  pattern = 'css',
  group = augroup,
  callback = function()
    vim.opt_local.iskeyword:append('-')
  end,
})
