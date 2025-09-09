local M = {}

local lint = require('lint')
local utils = require('core.utils')

lint.linters_by_ft = {
  javascript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescript = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  json = { 'jsonlint' },
  yaml = { 'yamllint' },
  python = { 'flake8', 'mypy' },
  sh = { 'shellcheck' },
  bash = { 'shellcheck' },
  zsh = { 'shellcheck' },
  php = { 'phpcs', 'phpstan' },
  dockerfile = { 'hadolint' },
  sql = { 'sqlfluff' },
  terraform = { 'tflint' },
  vim = { 'vint' },
  lua = { 'luacheck' },
  markdown = { 'markdownlint' },
  css = { 'stylelint' },
  scss = { 'stylelint' },
}

lint.linters.eslint_d.args = {
  '--no-warn-ignored',
  '--format',
  'json',
  '--stdin',
  '--stdin-filename',
  function()
    return vim.api.nvim_buf_get_name(0)
  end,
}

lint.linters.luacheck.args = {
  '--globals',
  'vim',
  '--formatter',
  'plain',
  '--codes',
  '--ranges',
  '-',
}

-- Configure mypy with dynamic Python environment detection
lint.linters.mypy = vim.tbl_deep_extend('force', lint.linters.mypy or {}, {
  cmd = 'mypy',
  args = function()
    local args = {
      '--show-error-codes',
      '--show-column-numbers',
      '--show-error-end',
      '--hide-error-context',
      '--no-color-output',
      '--no-error-summary',
      '--no-pretty',
      '--namespace-packages',
      '--follow-imports=silent',
      '--ignore-missing-imports',
    }

    local root_dir = vim.fn.getcwd()
    local python_path = utils.detect_python_path(root_dir)

    table.insert(args, '--python-executable')
    table.insert(args, python_path)

    return args
  end,
  stdin = true,
})

local config_cache = {}

-- Function to check if config files exist for linters
local function has_config_file(patterns)
  local cwd = vim.fn.getcwd()
  local cache_key = cwd .. ':' .. table.concat(patterns, ',')

  -- Check cache first
  if config_cache[cache_key] ~= nil then
    return config_cache[cache_key]
  end

  for _, pattern in ipairs(patterns) do
    if vim.fn.glob(pattern) ~= '' then
      config_cache[cache_key] = true
      return true
    end
  end

  config_cache[cache_key] = false
  return false
end

-- Only enable linters if they're installed and have config files
local function setup_conditional_linting()
  local ft = vim.bo.filetype
  local linters = lint.linters_by_ft[ft] or {}
  local available_linters = {}

  for _, linter in ipairs(linters) do
    if linter == 'eslint_d' and utils.is_executable('eslint_d') then
      if
        has_config_file({
          '.eslintrc.js',
          '.eslintrc.json',
          '.eslintrc.yaml',
          '.eslintrc.yml',
          'eslint.config.js',
          'eslint.config.mjs',
          'eslint.config.cjs',
          'package.json',
        })
      then
        table.insert(available_linters, linter)
      end
    elseif linter == 'phpcs' and utils.is_executable('phpcs') then
      if has_config_file({ 'phpcs.xml', 'phpcs.xml.dist', '.phpcs.xml' }) then
        table.insert(available_linters, linter)
      end
    elseif linter == 'flake8' and utils.is_executable('flake8') then
      if has_config_file({ '.flake8', 'setup.cfg', 'tox.ini', 'pyproject.toml' }) then
        table.insert(available_linters, linter)
      end
    elseif utils.is_executable(linter) then
      table.insert(available_linters, linter)
    end
  end

  if #available_linters > 0 then
    lint.try_lint(available_linters)
  end
end

vim.api.nvim_create_augroup('nvim_lint', { clear = true })

-- Defer linting on file open to prevent blocking
vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
  group = 'nvim_lint',
  callback = setup_conditional_linting,
})

-- Use a timer to lint after buffer is loaded to avoid blocking
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = 'nvim_lint',
  callback = function()
    vim.defer_fn(setup_conditional_linting, 100)
  end,
})

-- vim.keymap.set('n', '<Leader>ll', function()
--   lint.try_lint()
-- end, { desc = 'Lint buffer' })

vim.keymap.set('n', '<Leader>ll', lint.try_lint, { desc = 'Lint buffer' })

M.lint = lint

return M
