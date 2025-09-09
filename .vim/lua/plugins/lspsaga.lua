require('lspsaga').setup({
  rename = {
    quit = '<Esc>',
  },
  code_action = {
    keys = {
      quit = '<Esc>',
    },
  },
  definition = {
    quit = '<Esc>',
  },
  outline = {
    quit = '<Esc>',
  },
  callhierarchy = {
    keys = {
      quit = '<Esc>',
    },
  },
  symbol_in_winbar = {
    enable = true,
    separator = '  ',
    ignore_patterns = {},
    hide_keyword = true,
    show_file = true,
    folder_level = 2,
    respect_root = false,
    color_mode = true,
  },
})

vim.keymap.set('n', '<Leader>gp', ':Lspsaga finder<CR>', { desc = 'LSP finder', silent = true })
vim.keymap.set('n', 'gpd', ':Lspsaga peek_definition<CR>', { desc = 'Peek LSP definition', silent = true })
vim.keymap.set('n', 'gpt', ':Lspsaga peek_type_definition<CR>', { desc = 'Peek LSP type definition', silent = true })
vim.keymap.set('n', '<Leader>go', ':Lspsaga outline<CR>', { desc = 'LSP outline', silent = true })
vim.keymap.set('n', '<Leader>rn', ':Lspsaga rename<CR>', { desc = 'LSP rename', silent = true, noremap = true })
vim.keymap.set(
  'n',
  '<Leader>ic',
  ':Lspsaga incoming_calls<CR>',
  { desc = 'LSP incoming calls', silent = true, noremap = true }
)
vim.keymap.set(
  'n',
  '<Leader>oc',
  ':Lspsaga outgoing_calls<CR>',
  { desc = 'LSP outgoing calls', silent = true, noremap = true }
)
