require('copilot').setup({
  suggestion = { enabled = true },
  panel = { enabled = true },
  keymap = {},
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('CopilotFiletype', {}),
  pattern = { 'csv' },
  command = 'let b:copilot_enabled = 0',
  desc = 'Disable Copilot for specific filetypes',
})
