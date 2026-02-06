require('leap').setup({
  highlight_unlabeled_phase_one_targets = false,
  max_highlighted_traversal_targets = 10,
  equivalence_classes = { ' \t\r\n' },
  substitute_chars = {},
  keys = { next_target = '<enter>', prev_target = '<backspace>', next_group = '<space>', prev_group = '<backspace>' },
})

vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)', { silent = true, desc = 'Leap forward to' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)', { silent = true, desc = 'Leap backward to' })
