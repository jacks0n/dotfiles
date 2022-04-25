require'navigator'.setup({
  default_mapping = false,
  lsp_installer = true,
  lsp = {
    format_on_save = false
  },
  servers = {
    'tsserver'
  }
})
