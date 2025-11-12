local M = {}

local null_ls = require('null-ls')

local utils = require('core.utils')
local linters = require('core.linters')

local sources = {}
local config = linters.get_config()

local function has_builtin(kind, name)
  if kind == 'format' then
    return null_ls.builtins.formatting[name]
  elseif kind == 'lint' then
    return null_ls.builtins.diagnostics[name]
  end
end

local function build_condition(cfg, name)
  return function(ctx)
    local root = ctx.root
    if not root then return false end
    if not utils.is_executable(cfg.command or name) then return false end
    local patterns = cfg.patterns or {}
    for _, pattern in ipairs(patterns) do
      if ctx.path_exists(root .. '/' .. pattern) then return true end
    end
    return false
  end
end

for name, cfg in pairs(config) do
  if cfg.provides.format then
    local builtin = has_builtin('format', name)
    if builtin then table.insert(sources, builtin.with({ condition = build_condition(cfg, name) })) end
  end
  if cfg.provides.lint then
    local builtin = has_builtin('lint', name)
    if builtin then table.insert(sources, builtin.with({ condition = build_condition(cfg, name) })) end
  end
end

-- Custom xmlformat source (not provided by none-ls)
-- if config.xmlformat and utils.is_executable('xmlformat') then
--   local helpers = require('null-ls.helpers')
--   local methods = require('null-ls.methods')
--   local xml_cfg = config.xmlformat
--   local xml_source = helpers.make_builtin({
--     name = 'xmlformat',
--     meta = { url = 'https://github.com/chrisjenx/xmlformatter', description = 'Format XML via xmlformat' },
--     method = methods.internal.FORMATTING,
--     filetypes = xml_cfg.filetypes,
--     generator = helpers.formatter_factory({ command = 'xmlformat', args = {}, to_stdin = true }),
--   })
--   table.insert(sources, xml_source.with({ condition = build_condition(xml_cfg, 'xmlformat') }))
-- end

null_ls.setup({
  sources = sources,
  debounce = 150,
})

vim.api.nvim_create_user_command('FormatFile', function(opts)
  local bufnr = opts.args ~= '' and tonumber(opts.args) or 0
  if utils.is_large_file(bufnr) then return end
  vim.lsp.buf.format({
    bufnr = bufnr,
    timeout_ms = 3000,
    filter = function(client) return client.name == 'null-ls' end,
  })
end, { nargs = '?', desc = 'Format buffer via none-ls' })

return M

