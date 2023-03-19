local package_info = require('package-info');

package_info.setup({
  package_manager = 'npm',
  hide_up_to_date = true
})

vim.keymap.set('n', '<Leader>nd', package_info.delete, { noremap = true, silent = true, desc = 'Delete package' })
vim.keymap.set('n', '<Leader>nv', package_info.change_version, { noremap = true, silent = true, desc = 'Change version' })
vim.keymap.set('n', '<Leader>ni', package_info.install, { noremap = true, silent = true, desc = 'Install package' })
vim.keymap.set('n', '<Leader>nt', package_info.toggle, { noremap = true, silent = true, desc = 'Toggle version' })
vim.keymap.set('n', '<Leader>nu', package_info.update, { noremap = true, silent = true, desc = 'Update version' })
vim.keymap.set('n', '<Leader>ns', package_info.show, { noremap = true, silent = true, desc = 'Show package menu' })
vim.keymap.set('n', '<Leader>nh', package_info.hide, { noremap = true, silent = true, desc = 'Hide package menu' })
