local M = {}

-- Unified tool configuration (same structure). Only enabled when:
-- 1. Buffer is inside a git repo (git root detected).
-- 2. At least one listed pattern exists at that git root.
-- 3. Executable for the tool is available.
-- Each entry:
--   filetypes: list of supported filetypes
--   patterns: root-relative config filenames (any one enables tool)
--   args: list OR function(context) -> list (optional)
--   provides: { lint = bool, format = bool }
--   command (optional): override executable name
-- Context passed to args() includes { buf, root_dir }
local tool_config = {
  stylelint = {
    filetypes = { 'css', 'scss' },
    patterns = {
      '.stylelintrc', '.stylelintrc.js', '.stylelintrc.cjs', '.stylelintrc.mjs', '.stylelintrc.json',
      '.stylelintrc.yaml', '.stylelintrc.yml', 'stylelint.config.js', 'stylelint.config.cjs', 'stylelint.config.mjs', 'package.json',
    },
    provides = { lint = true, format = false },
  },
  -- jsonlint = {
  --   filetypes = { 'json' },
  --   patterns = { '.jsonlintrc', '.jsonlintrc.json', '.jsonlintrc.yaml', '.jsonlintrc.yml' },
  --   provides = { lint = true, format = false },
  -- },
  -- yamllint = {
  --   filetypes = { 'yaml' },
  --   patterns = { '.yamllint', '.yamllint.yaml', '.yamllint.yml' },
  --   provides = { lint = true, format = false },
  -- },
  -- flake8 = {
  --   filetypes = { 'python' },
  --   patterns = { '.flake8', 'setup.cfg', 'tox.ini', 'pyproject.toml' },
  --   provides = { lint = true, format = false },
  -- },
  -- mypy = {
  --   filetypes = { 'python' },
  --   patterns = { 'mypy.ini', 'setup.cfg', 'tox.ini', 'pyproject.toml' },
  --   provides = { lint = true, format = false },
  --   args = function(ctx)
  --     local python_path = require('core.utils').detect_python_path(ctx.root_dir)
  --     return {
  --       '--show-error-codes', '--show-column-numbers', '--show-error-end', '--hide-error-context', '--no-color-output',
  --       '--no-error-summary', '--no-pretty', '--namespace-packages', '--follow-imports=silent', '--ignore-missing-imports',
  --       '--python-executable', python_path,
  --     }
  --   end,
  -- },
  -- shellcheck = {
  --   filetypes = { 'sh', 'bash', 'zsh' },
  --   patterns = { '.shellcheckrc' },
  --   provides = { lint = true, format = false },
  -- },
  phpcs = {
    filetypes = { 'php' },
    patterns = { 'phpcs.xml', 'phpcs.xml.dist', '.phpcs.xml' },
    provides = { lint = true, format = false },
  },
  phpstan = {
    filetypes = { 'php' },
    patterns = { 'phpstan.neon', 'phpstan.neon.dist' },
    provides = { lint = true, format = false },
  },
  hadolint = {
    filetypes = { 'dockerfile' },
    patterns = { '.hadolint.yaml', '.hadolint.yml' },
    provides = { lint = true, format = false },
  },
  sqlfluff = {
    filetypes = { 'sql' },
    patterns = { '.sqlfluff', '.sqlfluff.toml' },
    provides = { lint = true, format = true },
  },
  -- tflint = {
  --   filetypes = { 'terraform' },
  --   patterns = { '.tflint.hcl' },
  --   provides = { lint = true, format = false },
  -- },
  terraform_fmt = {
    filetypes = { 'terraform' },
    patterns = { '.terraform-version', 'versions.tf', 'main.tf' },
    provides = { lint = false, format = true },
    mason_name = false,
  },
  vint = {
    filetypes = { 'vim' },
    patterns = { '.vintrc', '.vintrc.yaml', '.vintrc.yml' },
    provides = { lint = true, format = false },
  },
  -- luacheck = {
  --   filetypes = { 'lua' },
  --   patterns = { '.luacheckrc' },
  --   provides = { lint = true, format = false },
  --   args = { '--globals', 'vim', '--formatter', 'plain', '--codes', '--ranges', '-' },
  -- },
  stylua = {
    filetypes = { 'lua' },
    patterns = { 'stylua.toml', '.stylua.toml' },
    provides = { lint = false, format = true },
    args = function(ctx)
      return { '--search-parent-directories', '--stdin-filepath', vim.api.nvim_buf_get_name(ctx.buf) }
    end,
  },
  markdownlint = {
    filetypes = { 'markdown' },
    patterns = { '.markdownlint.yml', '.markdownlint.yaml', '.markdownlint.json', '.markdownlint.jsonc' },
    provides = { lint = true, format = false },
  },
  prettierd = {
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc', 'html', 'css', 'scss', 'markdown' },
    patterns = {
      '.prettierrc', '.prettierrc.js', '.prettierrc.cjs', '.prettierrc.mjs', '.prettierrc.json', '.prettierrc.yaml', '.prettierrc.yml',
      'prettier.config.js', 'prettier.config.cjs', 'prettier.config.mjs', 'package.json',
    },
    provides = { lint = false, format = true },
  },
  gofmt = {
    filetypes = { 'go' },
    patterns = { 'go.mod' },
    provides = { lint = false, format = true },
    mason_name = false,
  },
  -- rustfmt = {
  --   filetypes = { 'rust' },
  --   patterns = { 'Cargo.toml' },
  --   provides = { lint = false, format = true },
  --   mason_name = false,
  -- },
  clang_format = {
    filetypes = { 'c', 'cpp' },
    patterns = { '.clang-format', '_clang-format' },
    provides = { lint = false, format = true },
    mason_name = 'clang-format',
  },
  -- xmlformat = {
  --   filetypes = { 'xml' },
  --   patterns = { '.xmlformatrc', '.xmlformatterrc', '.editorconfig' },
  --   provides = { lint = false, format = true },
  --   mason_name = 'xmlformatter',
  -- },
}

local utils = require('core.utils')

local function git_root(bufnr)
  return utils.find_git_root(bufnr)
end

local function has_config(patterns, root_dir)
  if not patterns or not root_dir then return false end
  for _, pattern in ipairs(patterns) do
    if vim.fn.filereadable(root_dir .. '/' .. pattern) == 1 then return true end
  end
  return false
end

function M.get_config() return tool_config end

function M.tool_enabled(name, bufnr)
  local cfg = tool_config[name]
  if not cfg then return false end
  local root_dir = git_root(bufnr)
  if not root_dir then return false end
  if not utils.is_executable(cfg.command or name) then return false end
  if not has_config(cfg.patterns, root_dir) then return false end
  return true
end

function M.active_tools(ft, kind, bufnr)
  local results = {}
  for name, cfg in pairs(tool_config) do
    if cfg.provides[kind] and vim.tbl_contains(cfg.filetypes, ft) and M.tool_enabled(name, bufnr) then
      table.insert(results, name)
    end
  end
  return results
end

return M
