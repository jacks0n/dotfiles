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
    ignore_patterns={},
    hide_keyword = true,
    show_file = true,
    folder_level = 2,
    respect_root = false,
    color_mode = true,
  }
})

vim.keymap.set('n', '<Leader>gp', ':Lspsaga lsp_finder<CR>', { desc = 'LSP finder', silent = true })
vim.keymap.set('n', '<Leader>gd', ':Lspsaga peek_definition<CR>', { desc = 'Peek LSP definition', silent = true })
vim.keymap.set('n', '<Leader>gt', ':Lspsaga peek_type_definition<CR>', { desc = 'Peek LSP type definition', silent = true })
vim.keymap.set('n', '<Leader>go', ':Lspsaga outline<CR>', { desc = 'LSP outline', silent = true })
vim.keymap.set('n', '<Leader>rn', ':Lspsaga rename<CR>', { desc = 'LSP rename', silent = true, noremap = true, buffer = bufnr })
