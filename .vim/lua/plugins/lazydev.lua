local M = {}

local status_ok, lazydev = pcall(require, 'lazydev')
if not status_ok then
  return M
end

lazydev.setup({
  library = {
    { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    { path = 'LazyVim', words = { 'LazyVim' } },
    { path = 'lazy.nvim', words = { 'lazy' } },
  },
  runtime = vim.env.VIMRUNTIME,
  types = true,
  integrations = {
    lspconfig = true,
    cmp = true,
  },
})

return M
