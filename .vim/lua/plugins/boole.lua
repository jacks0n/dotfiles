local keymap = require('core.keymap')
require('boole').setup({
  mappings = {
    increment = '<C-Char-' .. keymap['='] .. '>',
    decrement = '<C-Char-' .. keymap['-'] .. '>',
  },
  allow_caps_additions = {
    {'enable', 'disable'}
  }
})
