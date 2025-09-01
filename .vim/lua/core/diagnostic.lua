-- Configure diagnostic behavior
vim.diagnostic.config({
  virtual_lines = true,
  -- Disable virtual text to reduce clutter
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '⚑',
    },
    severity = { min = vim.diagnostic.severity.HINT },
    priority = 20,
  },
  underline = {
    severity = { min = vim.diagnostic.severity.HINT },
  },
  update_in_insert = false, -- Don't show diagnostics while typing
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
    max_width = 80,
    max_height = 20,
    wrap = true,
    close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost', 'BufHidden', 'WinLeave' },
  },
})

-- Set up diagnostic keymaps
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

-- Customize diagnostic severity navigation
vim.keymap.set('n', '[e', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Go to previous error' })

vim.keymap.set('n', ']e', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Go to next error' })

vim.keymap.set('n', '[w', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
end, { desc = 'Go to previous warning' })

vim.keymap.set('n', ']w', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
end, { desc = 'Go to next warning' })

-- Toggle diagnostics
-- vim.keymap.set('n', '<leader>dd', function()
--   vim.diagnostic.disable()
--   vim.notify('Diagnostics disabled')
-- end, { desc = 'Disable diagnostics' })
--
-- vim.keymap.set('n', '<leader>de', function()
--   vim.diagnostic.enable()
--   vim.notify('Diagnostics enabled')
-- end, { desc = 'Enable diagnostics' })

-- Configure diagnostic highlights
vim.cmd([[
  highlight DiagnosticError guifg=#f38ba8 ctermfg=1
  highlight DiagnosticWarn guifg=#f9e2af ctermfg=3
  highlight DiagnosticInfo guifg=#89b4fa ctermfg=4
  highlight DiagnosticHint guifg=#a6e3a1 ctermfg=2
  highlight DiagnosticUnderlineError gui=underline guisp=#f38ba8 cterm=underline
  highlight DiagnosticUnderlineWarn gui=underline guisp=#f9e2af cterm=underline
  highlight DiagnosticUnderlineInfo gui=underline guisp=#89b4fa cterm=underline
  highlight DiagnosticUnderlineHint gui=underline guisp=#a6e3a1 cterm=underline
]])

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost', 'BufHidden', 'WinLeave' },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})
