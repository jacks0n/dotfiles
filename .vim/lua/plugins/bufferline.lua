require('bufferline').setup {
  options = {
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(_count, _level, diagnostics_dict)
      local s = {}
      for type, num in pairs(diagnostics_dict) do
        if type == 'error' then
          table.insert(s, num .. ' ')
        elseif type == 'warning' then
          table.insert(s, num .. ' ')
        else
          table.insert(s, num .. ' ')
        end
      end
      return table.concat(s, '  ') .. ' '
    end,
    diagnostics_update_in_insert = false,
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    -- Deprecated.
    -- show_buffer_default_icon = true,
    show_close_icon = true,
    indicator = {
      style = 'icon'
    },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = 'thin',
    enforce_regular_tabs = true,
    always_show_bufferline = true,
    sort_by = 'insert_after_current',
    highlights = {
      background = { italic = true },
      buffer_selected = { bold = true },
    },
    hover = {
      enabled = true,
      delay = 50,
      reveal = { 'close' }
    }
  },
}

vim.keymap.set('n', '<Leader>,', ':lclose<CR>:BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<Leader>.', ':lclose<CR>:BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<C-Tab>', ':lclose<CR>:BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<C-S-Tab>', ':lclose<CR>:BufferLineCycleNext<CR>', { desc = 'Next buffer' })
