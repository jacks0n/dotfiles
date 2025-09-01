require('copilot').setup({
  suggestion = { enabled = false }, -- Disable suggestions since blink.cmp will handle completion
  panel = { enabled = false }, -- Disable panel to avoid conflicts with blink.cmp
  keymap = {},
  filetypes = {
    gitignore = false,
    ['.gitignore'] = false,
  },
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('CopilotFiletype', {}),
  pattern = { 'csv', 'gitignore' },
  callback = function()
    vim.b.copilot_enabled = false
  end,
  desc = 'Disable Copilot for specific filetypes',
})
