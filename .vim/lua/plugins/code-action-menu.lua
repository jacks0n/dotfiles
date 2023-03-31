vim.keymap.set(
  'n',
  'ca',
  require('code_action_menu').open_code_action_menu,
  { desc = 'LSP code action menu' }
)
