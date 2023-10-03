local navbuddy = require('nvim-navbuddy')

navbuddy.setup({
  window = {
    size = '80%',
  },
})

vim.keymap.set('n', '<Leader>l', navbuddy.open, { desc = 'Navbuddy LSP breadcrumbs' })
