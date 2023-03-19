local tsj = require('treesj')

local langs = {}

tsj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 1000,
  cursor_behavior = 'hold',
  notify = true,
  langs = langs,
})

vim.keymap.set('n', '<Leader>j', ':TSJToggle<CR>', { noremap = true })
