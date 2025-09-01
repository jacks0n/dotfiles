require('noice').setup({
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['blink.cmp.entry.get_documentation'] = true,
    },
    signature = {
      enabled = true,
    },
    hover = {
      enabled = false,
    },
  },
  presets = {
    lsp_doc_border = true,
  },
  messages = {
    enabled = false,
  },
  notify = {
    enabled = true,
  },
  popupmenu = {
    backend = 'blink',
  },
  cmdline = {
    enabled = false,
    view = 'cmdline',
  },
})

vim.keymap.set({ 'n', 'i', 's' }, '<C-j>', function()
  if not require('noice.lsp').scroll(4) then
    return '<C-j>'
  end
end, { silent = true, expr = true })

vim.keymap.set({ 'n', 'i', 's' }, '<C-k>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<C-k>'
  end
end, { silent = true, expr = true })
