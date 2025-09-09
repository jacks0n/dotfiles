local trouble = require('trouble')

trouble.setup()

local function next()
  trouble.next({ skip_groups = true, jump = true })
end
local function previous()
  trouble.previous({ skip_groups = true, jump = true })
end

vim.keymap.set('n', '<Leader>xx', ':Trouble diagnostics toggle filter.buf=0', { desc = 'Toggle buffer diagnostics' })
vim.keymap.set('n', '<Leader>xw', ':Trouble diagnostics toggle', { desc = 'Toggle workspace diagnostics' })
vim.keymap.set('n', ']x', next, { desc = 'Next Trouble item' })
vim.keymap.set('n', '[x', previous, { desc = 'Previous Trouble item' })
