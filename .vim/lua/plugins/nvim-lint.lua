local linters_core = require('core.linters')
local ok, lint = pcall(require, 'lint')
if not ok then return end

-- Build static map from unified config (only lint providers)
lint.linters_by_ft = {}
local cfg = linters_core.get_config()
for name, entry in pairs(cfg) do
  if entry.provides.lint then
    for _, ft in ipairs(entry.filetypes) do
      local list = lint.linters_by_ft[ft] or {}
      table.insert(list, name)
      lint.linters_by_ft[ft] = list
    end
  end
end

local function tool_args(name, bufnr)
  local entry = cfg[name]
  if not entry or not entry.args then return nil end
  local root = require('core.utils').find_git_root(bufnr)
  local ctx = { buf = bufnr, root_dir = root }
  if type(entry.args) == 'function' then return entry.args(ctx) end
  local out = {}
  for _, a in ipairs(entry.args) do
    if type(a) == 'function' then table.insert(out, a(ctx)) else table.insert(out, a) end
  end
  return out
end

local function run_lint(bufnr)
  bufnr = bufnr or 0
  local ft = vim.bo[bufnr].filetype
  local configured = lint.linters_by_ft[ft]
  if not configured then return end
  local to_run = {}
  for _, name in ipairs(configured) do
    if linters_core.tool_enabled(name, bufnr) then
      local args = tool_args(name, bufnr)
      if args then lint.linters[name].args = args end
      table.insert(to_run, name)
    end
  end
  if #to_run > 0 then lint.try_lint(to_run) end
end

vim.api.nvim_create_augroup('nvim_lint_dynamic', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, { group = 'nvim_lint_dynamic', callback = function(a) run_lint(a.buf) end })
vim.api.nvim_create_autocmd('BufWinEnter', { group = 'nvim_lint_dynamic', callback = function(a) vim.defer_fn(function() run_lint(a.buf) end, 100) end })

vim.keymap.set('n', '<leader>ll', function() run_lint(0) end, { desc = 'Lint buffer (conditional)' })
