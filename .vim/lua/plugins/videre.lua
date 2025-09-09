local videre = require('videre')
videre.setup({})

vim.api.nvim_create_user_command('JsonGraphEdit', 'Videre', {
  nargs = '*',
  desc = 'Alias for Videre JSON editor',
})
