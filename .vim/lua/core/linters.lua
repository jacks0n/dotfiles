local M = {}

-- Setup conform.nvim for formatting
local conform_ok, conform = pcall(require, 'conform')
if not conform_ok then
  return M
end

conform.setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd', 'prettier' },
    javascriptreact = { 'prettierd', 'prettier' },
    typescript = { 'prettierd', 'prettier' },
    typescriptreact = { 'prettierd', 'prettier' },
    json = { 'prettierd', 'prettier' },
    jsonc = { 'prettierd', 'prettier' },
    yaml = { 'prettierd', 'prettier' },
    html = { 'prettierd', 'prettier' },
    css = { 'prettierd', 'prettier' },
    scss = { 'prettierd', 'prettier' },
    markdown = { 'prettierd', 'prettier' },
    python = { 'black', 'isort' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
    php = { 'php_cs_fixer' },
    go = { 'gofmt' },
    rust = { 'rustfmt' },
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    xml = { 'xmlformat' },
    sql = { 'sqlfluff' },
    terraform = { 'terraform_fmt' },
  },
  default_format_opts = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_format = 'fallback',
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
  format_after_save = {
    lsp_format = 'fallback',
  },
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,
})

-- Setup nvim-lint for linting
local lint = require('lint')

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

-- Custom linter configurations
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

-- Function to check if a linter/formatter is available
local function is_executable(name)
  return vim.fn.executable(name) == 1
end

-- Cache for config file detection
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
    if linter == 'eslint_d' and is_executable('eslint_d') then
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
    elseif linter == 'phpcs' and is_executable('phpcs') then
      if has_config_file({ 'phpcs.xml', 'phpcs.xml.dist', '.phpcs.xml' }) then
        table.insert(available_linters, linter)
      end
    elseif linter == 'flake8' and is_executable('flake8') then
      if has_config_file({ '.flake8', 'setup.cfg', 'tox.ini', 'pyproject.toml' }) then
        table.insert(available_linters, linter)
      end
    elseif is_executable(linter) then
      table.insert(available_linters, linter)
    end
  end

  if #available_linters > 0 then
    lint.try_lint(available_linters)
  end
end

-- Set up autocommands for linting
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

-- Set up autocommands for formatting
vim.api.nvim_create_augroup('conform_format', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'conform_format',
  callback = function(args)
    -- Don't format if the file is too large
    local max_filesize = 100 * 1024 -- 100KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then
      return
    end

    -- Format the buffer
    conform.format({
      bufnr = args.buf,
      timeout_ms = 3000,
      quiet = true,
    })
  end,
})

-- Set up file type detection for special cases
vim.api.nvim_create_autocmd('BufReadPre', {
  group = 'conform_format',
  desc = 'Set OpenAPI yaml file types',
  pattern = { '*.openapi.yaml', '*.openapi.yml', '*.swagger.yaml', '*.swagger.yml' },
  callback = function(args)
    vim.bo[args.buf].filetype = 'yaml.openapi'
  end,
})

vim.api.nvim_create_autocmd('BufReadPre', {
  group = 'conform_format',
  desc = 'Set GitHub Actions workflow file types',
  pattern = { '.github/workflows/*.yml', '.github/workflows/*.yaml' },
  callback = function(args)
    vim.bo[args.buf].filetype = 'yaml.github'
  end,
})

-- Key mappings for manual formatting and linting
vim.keymap.set('n', '<leader>fm', function()
  conform.format({ timeout_ms = 3000 })
end, { desc = 'Format buffer' })

vim.keymap.set('n', '<leader>fl', function()
  lint.try_lint()
end, { desc = 'Lint buffer' })

vim.keymap.set('v', '<leader>fm', function()
  conform.format({ range = true })
end, { desc = 'Format selection' })

-- Command to toggle format on save
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
M.lint = lint

return M
