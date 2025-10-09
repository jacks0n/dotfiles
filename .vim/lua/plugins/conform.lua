local M = {}

local conform = require('conform')

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
    -- python = { 'black', 'isort' },
    python = { 'ruff' },
    -- sh = { 'shfmt' },
    -- bash = { 'shfmt' },
    -- zsh = { 'shfmt' },
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

-- Set up autocommands for formatting
vim.api.nvim_create_augroup('conform_format', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'conform_format',
  callback = function(args)
    -- Don't format if the file is too large
    local max_filesize = 100 * 1024 -- 100KB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
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

vim.keymap.set('n', 'gf', function()
  conform.format({ timeout_ms = 3000 })
end, { desc = 'Format buffer' })

vim.keymap.set('n', '<leader>fm', function()
  conform.format({ timeout_ms = 3000 })
end, { desc = 'Format buffer' })

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

return M
