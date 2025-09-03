local M = {}

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

-- Configure mypy with dynamic Python environment detection
lint.linters.mypy = vim.tbl_deep_extend('force', lint.linters.mypy, {
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

    -- Detect Python environment for current project
    local root_dir = vim.fn.getcwd()
    local python_path = nil

    -- Check for local virtual environments
    local venv_dirs = { '.venv', 'venv', 'env', '.env' }
    for _, vdir in ipairs(venv_dirs) do
      local venv_python = root_dir .. '/' .. vdir .. '/bin/python'
      if vim.fn.filereadable(venv_python) == 1 then
        python_path = venv_python
        break
      end
    end

    -- Try Poetry
    if not python_path then
      local poetry_cmd = string.format('cd %s && poetry env info --path 2>/dev/null', vim.fn.shellescape(root_dir))
      local poetry_venv = vim.fn.system(poetry_cmd)
      if vim.v.shell_error == 0 and poetry_venv ~= '' then
        python_path = vim.trim(poetry_venv) .. '/bin/python'
      end
    end

    -- Try Pipenv
    if not python_path then
      local pipenv_cmd = string.format('cd %s && pipenv --venv 2>/dev/null', vim.fn.shellescape(root_dir))
      local pipenv_venv = vim.fn.system(pipenv_cmd)
      if vim.v.shell_error == 0 and pipenv_venv ~= '' then
        python_path = vim.trim(pipenv_venv) .. '/bin/python'
      end
    end

    -- Check environment variables
    if not python_path then
      if vim.env.VIRTUAL_ENV then
        python_path = vim.env.VIRTUAL_ENV .. '/bin/python'
        if vim.fn.filereadable(python_path) ~= 1 then
          python_path = nil
        end
      elseif vim.env.CONDA_PREFIX then
        python_path = vim.env.CONDA_PREFIX .. '/bin/python'
        if vim.fn.filereadable(python_path) ~= 1 then
          python_path = nil
        end
      end
    end

    -- If we found a Python path, add it to args
    if python_path then
      table.insert(args, '--python-executable')
      table.insert(args, python_path)
    end

    return args
  end,
  stdin = true,
})

-- Function to check if a linter is available
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

-- Key mapping for manual linting
vim.keymap.set('n', '<leader>fl', function()
  lint.try_lint()
end, { desc = 'Lint buffer' })

M.lint = lint

return M