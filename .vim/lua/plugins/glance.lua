local glance = require('glance')
local actions = glance.actions

glance.setup({
  mappings = {
    preview = {
      ['<Esc>'] = actions.close,
      ['<Tab>'] = actions.next_location,
      ['<S-Tab>'] = actions.previous_location,
      ['<leader>l'] = actions.enter_win('list'),
    },
  },
})

vim.keymap.set('n', '<Leader>gd', '<CMD>Glance definitions<CR>')
vim.keymap.set('n', '<Leader>gD', '<CMD>Glance type_definitions<CR>')
vim.keymap.set('n', '<Leader>gr', '<CMD>Glance references<CR>')
vim.keymap.set('n', '<Leader>gi', '<CMD>Glance implementations<CR>')
