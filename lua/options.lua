local opt = vim.opt

opt.backspace = { 'indent', 'eol', 'start' } -- allow b/s over everything in insert mode
opt.breakindent = true -- smart/indented line wrapping
opt.confirm = true -- confirm dialog instead of fail
opt.dict:append('~/.config/nvim/dictionaries/wordlist.dict')
opt.foldenable = false
opt.foldmethod = 'indent'
opt.formatoptions:append('j') -- make J command grok multiline code comments
opt.iskeyword:remove('_') -- make _ act as a word boundary
opt.mouse = 'a'
opt.nrformats = '' -- force decimal-based arithmetic on ctrl-a/x
opt.scrolloff = 10
opt.showmatch = true -- highlight matching parens, etc.
opt.splitbelow = true -- make preview window open to bottom
opt.splitright = true -- make :vert <whatever> open to right
opt.undofile = true
opt.undodir = vim.fn.stdpath('data') .. '/undo'
opt.updatetime = 300  -- 300ms delay for CursorHold
opt.wildmenu = true -- waaaaay better tab completion
opt.wildmode = { 'list', 'longest', 'full' }
opt.wildignore:append { '*/.git/*', '*/tmp/*', '*.so', '*.swp', '*.zip' }
opt.wildignorecase = true

opt.incsearch = true  -- do incremental searching
opt.ignorecase = true --   make / searches ignore case
opt.smartcase = true  --   unless there's a capital in the expression

opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 4
opt.softtabstop = 4
