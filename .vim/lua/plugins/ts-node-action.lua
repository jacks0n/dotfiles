require('ts-node-action').setup({
  ['typescriptreact.typescript'] = require('ts-node-action.filetypes.javascript'),
})

vim.keymap.set({ 'n' }, 'ta', require('ts-node-action').node_action, { desc = 'Trigger Node Action' })
