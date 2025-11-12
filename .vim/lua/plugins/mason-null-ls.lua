local mason_null_ls = require('mason-null-ls')
local linters = require('core.linters')

local config = linters.get_config()
local ensure_installed = {}

for name, cfg in pairs(config) do
  local mason_name = cfg.mason_name
  if mason_name ~= false then
    table.insert(ensure_installed, mason_name or name)
  end
end

mason_null_ls.setup({
  ensure_installed = ensure_installed,
  automatic_installation = true,
  handlers = {},
})

return {}
