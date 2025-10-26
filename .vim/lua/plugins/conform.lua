local M = {}

local conform = require('conform')
local linters = require('core.linters')
local utils = require('core.utils')

conform.setup({
  formatters_by_ft = {}, -- we resolve dynamically
  default_format_opts = { timeout_ms = 3000, async = false, quiet = false, lsp_format = 'fallback' },
  format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
  format_after_save = { lsp_format = 'fallback' },
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,
})

local function gather_args(name, bufnr)
  local cfg = linters.get_config()[name]
  if not cfg or not cfg.args then return nil end
  local root = utils.find_git_root(bufnr)
  local ctx = { buf = bufnr, root_dir = root }
  if type(cfg.args) == 'function' then return cfg.args(ctx) end
  local out = {}
  for _, a in ipairs(cfg.args) do
    if type(a) == 'function' then table.insert(out, a(ctx)) else table.insert(out, a) end
  end
  return out
end

local function format_names(bufnr)
  local ft = vim.bo[bufnr].filetype
  return linters.active_tools(ft, 'format', bufnr)
end

local function apply_overrides(names, bufnr)
  local overrides = {}
  for _, name in ipairs(names) do
    local args = gather_args(name, bufnr)
    if args then overrides[name] = { prepend_args = args } end
  end
  for k, v in pairs(overrides) do conform.formatters[k] = vim.tbl_extend('force', conform.formatters[k] or {}, v) end
end

local function do_format(bufnr, opts)
  bufnr = bufnr or 0
  if utils.is_large_file(bufnr) then return end
  local names = format_names(bufnr)
  apply_overrides(names, bufnr)
  conform.format(vim.tbl_extend('force', { bufnr = bufnr, timeout_ms = 3000, quiet = true, formatters = names }, opts or {}))
end

vim.api.nvim_create_augroup('conform_format', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', { group = 'conform_format', callback = function(args) if not vim.g.disable_autoformat then do_format(args.buf) end end })

-- Filetype tweaks
vim.api.nvim_create_autocmd('BufReadPre', {
  group = 'conform_format',
  pattern = { '*.openapi.yaml', '*.openapi.yml', '*.swagger.yaml', '*.swagger.yml' },
  callback = function(args) vim.bo[args.buf].filetype = 'yaml.openapi' end,
})
vim.api.nvim_create_autocmd('BufReadPre', {
  group = 'conform_format',
  pattern = { '.github/workflows/*.yml', '.github/workflows/*.yaml' },
  callback = function(args) vim.bo[args.buf].filetype = 'yaml.github' end,
})

-- Keymaps
vim.keymap.set('n', 'gf', function() do_format(0) end, { desc = 'Format buffer' })
vim.keymap.set('n', '<leader>fm', function() do_format(0) end, { desc = 'Format buffer' })
vim.keymap.set('v', '<leader>fm', function() conform.format({ range = true }) end, { desc = 'Format selection' })

vim.api.nvim_create_user_command('FormatToggle', function()
  if vim.g.disable_autoformat then
    vim.g.disable_autoformat = false
    conform.setup({ format_on_save = { timeout_ms = 500, lsp_format = 'fallback' } })
    vim.notify('Format on save enabled')
  else
    vim.g.disable_autoformat = true
    conform.setup({ format_on_save = false })
    vim.notify('Format on save disabled')
  end
end, { desc = 'Toggle format on save' })

M.conform = conform
return M
