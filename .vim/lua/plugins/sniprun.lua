require('sniprun').setup({
  display = {
    'TempFloatingWindow',
  },
})

vim.keymap.set('n', '<Leader>ru', ':SnipRun<CR>', { noremap = true })
vim.keymap.set('v', '<Leader>ru', ':SnipRun<CR>', { noremap = true })
