local debugpy_path = vim.fn.expand('~/.local/share/uv/tools/debugpy/bin/python')

if vim.fn.executable(debugpy_path) == 1 then
    require('dap-python').setup(debugpy_path)

    vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint'})
    vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = 'Debug: Start/Continue'})
    vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end, { desc = 'Debug: Open REPL' })
    vim.keymap.set('n', '<leader>do', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>du', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>dt', function() require('dap').terminate() end, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<leader>dh', function() require('dap.ui.widgets').hover() end, { desc = 'Debug: Hover' })

end
