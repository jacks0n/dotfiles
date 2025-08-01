local M = {}

-- Setup mason-conform for automatic installation of formatters
local status_ok, mason_conform = pcall(require, 'mason-conform')
if not status_ok then
  return M
end

mason_conform.setup({
  -- Most settings are automatic, just need to call setup
  -- mason-conform will automatically install formatters configured in conform.nvim
})

return M