local M = {}

-- Setup mason-nvim-lint for automatic installation of linters
local status_ok, mason_nvim_lint = pcall(require, 'mason-nvim-lint')
if not status_ok then
  return M
end

mason_nvim_lint.setup({
  -- Most settings are automatic, just need to call setup
  -- mason-nvim-lint will automatically install linters configured in nvim-lint
  automatic_installation = true,
  ensure_installed_sync = false, -- Prevent concurrent installation attempts
})

return M