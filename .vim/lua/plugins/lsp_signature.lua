require('lsp_signature').setup({
  always_trigger = false, -- Always show signature when typing
  auto_close_after = nil, -- Auto close after X seconds
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  doc_lines = 10, -- Will show two lines of comment/doc
  fix_pos = false,
  floating_window = true,
  floating_window_above_cur_line = true, -- Try to place window above current line
  floating_window_off_x = 1, -- Adjust float window x position
  floating_window_off_y = 0, -- Adjust float window y position
  hi_parameter = 'LspSignatureActiveParameter', -- Highlight group for current parameter
  hint_enable = true,
  hint_prefix = '🔍 ', -- Parameter hint prefix
  hint_scheme = 'String', -- Highlight group for virtual hint
  max_height = 20, -- Max height of signature floating window
  max_width = 80, -- Max width of floating window
  noice = true,
  padding = '', -- Character to pad on left and right of signature
  select_signature_key = '<C-n>', -- Cycle through multiple signatures
  shadow_blend = 36, -- Blend for shadow window
  shadow_guibg = 'Black', -- Background color for shadow
  timer_interval = 200, -- Default timer check interval
  toggle_key = '<C-K>', -- Toggle signature on/off in insert mode
  transparency = nil, -- 1-100, nil for no transparency
  wrap = true, -- Wrap long lines
  handler_opts = {
    border = 'rounded', -- rounded, single, double, shadow, none
  },
  hint_inline = function()
    return false -- Disable inline hints (use floating window instead)
  end,
})
