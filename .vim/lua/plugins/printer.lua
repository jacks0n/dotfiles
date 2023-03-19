require('printer').setup({
  formatters = {
    typescript = function(inside, variable)
      return string.format("console.log('DEBUG %s', JSON.stringify(%s, null, 2));", inside, variable)
    end,
  },
  add_to_inside = function(text)
    return string.format('[%s:%s] %s', vim.fn.expand('%'), vim.fn.line('.') + 1, text)
  end,
})

vim.keymap.set('n', 'g?', '<Plug>(printer_print)iw')
