local augend = require('dial.augend')
require('dial.config').augends:register_group({
  default = {
    augend.constant.alias.bool,
    augend.semver.alias.semver,
    augend.constant.alias.alpha,
    augend.constant.alias.Alpha,
    augend.integer.alias.decimal_int,
    augend.integer.alias.hex,
    augend.date.alias['%Y/%m/%d'],
    augend.date.alias['%m/%d/%Y'],
    augend.date.alias['%d/%m/%Y'],
    augend.date.alias['%m/%d/%y'],
    augend.date.alias['%m/%d'],
    augend.date.alias['%Y-%m-%d'],
    augend.date.alias['%H:%M:%S'],
    augend.date.alias['%H:%M'],
    augend.constant.alias.ja_weekday_full,
    augend.constant.new({
      elements = { '&&', '||' },
      word = false,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { 'eslint-enable', 'eslint-disable' },
      word = false,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { 'TRUE', 'FALSE' },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { 'off', 'on' },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { 'true', 'false' },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { 'True', 'False' },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { 'no', 'yes' },
      cyclic = false,
      preserve_case = true,
    }),
    augend.constant.new({
      elements = { 'off', 'on' },
      cyclic = false,
      preserve_case = true,
    }),
    augend.constant.new({
      elements = { 'and', 'or' },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { '&&', '||' },
      word = false,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday' },
      word = true,
      cyclic = true,
    }),
  },
})

local dial_manipulate_keep_cursor_position = function(direction)
  local pos = vim.api.nvim_win_get_cursor(0)
  local cmd = direction == 'increment' and require('dial.map').inc_normal() or require('dial.map').dec_normal()
  local keys = vim.api.nvim_replace_termcodes(cmd, true, true, true)
  vim.api.nvim_feedkeys(keys, 'm', false)
  vim.schedule(function()
    vim.api.nvim_win_set_cursor(0, pos)
  end)
end

vim.keymap.set('n', '-', function()
  dial_manipulate_keep_cursor_position('decrement')
end)
vim.keymap.set('n', '+', function()
  dial_manipulate_keep_cursor_position('increment')
end)
