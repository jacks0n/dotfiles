require('leap').setup({
  max_phase_one_targets = nil,
  highlight_unlabeled_phase_one_targets = false,
  max_highlighted_traversal_targets = 10,
  case_sensitive = false,
  equivalence_classes = { ' \t\r\n',  },
  substitute_chars = {},
  special_keys = { repeat_search = '<enter>', next_phase_one_target = '<enter>', next_target = { '<enter>', ';' }, prev_target = { '<tab>', ',' }, next_group = '<space>', prev_group = '<tab>', multi_accept = '<enter>', multi_revert = '<backspace>',  },
})

vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)', { silent = true, desc = 'Leap forward to' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)', { silent = true, desc = 'Leap backward to' })
