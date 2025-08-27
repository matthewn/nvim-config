-- useful for highlight debugging
local function syn_group()
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  local syn_id = vim.fn.synID(line, col, 1)
  local syn_name = vim.fn.synIDattr(syn_id, 'name')
  local trans_name = vim.fn.synIDattr(vim.fn.synIDtrans(syn_id), 'name')
  print(syn_name .. ' -> ' .. trans_name)
end
-- make the function available as a command
vim.api.nvim_create_user_command('SynGroup', syn_group, {})
