require('copilot').setup({
  suggestion = { enabled = true },
  panel = { enabled = true },
  keymap = {},
  filetypes = {
    gitignore = false,
    ['.gitignore'] = false,
  },
})

-- Setup copilot-cmp
require('copilot_cmp').setup({
  fix_pairs = true,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('CopilotFiletype', {}),
  pattern = { 'csv', 'gitignore' },
  callback = function()
    vim.b.copilot_enabled = false
  end,
  desc = 'Disable Copilot for specific filetypes',
})
