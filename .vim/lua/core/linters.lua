local lsp = require('lsp-zero')
local null_ls = require('null-ls')
local null_opts = lsp.build_options('null-ls', {})
local mason_null_ls = require('mason-null-ls')
local core_utils = require('core.utils')
local null_ls_helpers = require('null-ls.helpers')
local null_ls_utils = require('null-ls.utils')
local cmd_resolver = require('null-ls.helpers.command_resolver')

null_ls.setup({
  on_attach = null_opts.on_attach,
  debug = true,
  should_attach = function(bufnr)
    return not core_utils.is_large_file(bufnr) and not core_utils.is_in_undo_dir(bufnr)
  end,
  sources = {
    -- Shell.
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.zsh,

    -- CloudFormation.
    null_ls.builtins.diagnostics.cfn_lint,

    -- Lua.
    -- null_ls.builtins.formatting.lua_format,
    -- null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.diagnostics.luacheck,

    -- PHP.
    null_ls.builtins.diagnostics.php,
    -- null_ls.builtins.diagnostics.phpmd,
    -- null_ls.builtins.diagnostics.phpstan,
    null_ls.builtins.formatting.phpcsfixer.with({
      condition = function(utils)
        return utils.root_has_file({
          '.php-cs-fixer.dist.php', '.php-cs-fixer.php'
        })
      end
    }),

    -- CSS/Sass/SCSS/Less.
    null_ls.builtins.diagnostics.stylelint.with({
      condition = function(utils)
        return utils.root_has_file({
          '.stylelintrc', '.stylelintrc.js', '.stylelintrc.json',
          '.stylelintrc.yml', '.stylelintrc.yaml',
          'stylelint.config.js', 'stylelint.config.cjs'
        })
      end
    }),

    -- GitHub Actions.
    null_ls.builtins.diagnostics.actionlint.with({
      runtime_condition = function(params)
        local bufpath = vim.api.nvim_buf_get_name(params.bufnr)
        return (
          string.match(bufpath, '^.github/workflows/.*.ya?ml') ~= nil
          or string.match(bufpath, 'action.yml$') ~= nil
        )
      end
    }),

    -- Vim Script.
    null_ls.builtins.diagnostics.vint,

    -- Python.
    null_ls.builtins.formatting.autopep8,

    -- FIXME Installation fails.
    -- null_ls.builtins.diagnostics.vamllint,

    -- JS/TS/JSX/TSX/Vue.
    -- null_ls.builtins.formatting.eslint_d.with({
    --   filetypes = {
    --     'javascript',
    --     'javascriptreact',
    --     'typescript',
    --     'typescriptreact',
    --     'vue',
    --     'typescriptreact.typescript',
    --   },
    -- }),
    -- null_ls.builtins.code_actions.eslint_d.with({
    --   filetypes = {
    --     'javascript',
    --     'javascriptreact',
    --     'typescript',
    --     'typescriptreact',
    --     'vue',
    --     'typescriptreact.typescript',
    --   },
    -- }),
    -- null_ls.builtins.diagnostics.eslint_d.with({
    --   filetypes = {
    --     'javascript',
    --     'javascriptreact',
    --     'typescript',
    --     'typescriptreact',
    --     'vue',
    --     'typescriptreact.typescript',
    --   },
    -- }),
    -- null_ls.builtins.formatting.prettierd.with({
    --   filetypes = {
    --     'javascript',
    --     'javascriptreact',
    --     'typescript',
    --     'typescriptreact',
    --     'vue',
    --     'typescriptreact.typescript',
    --   },
    -- }),
    require('typescript.extensions.null-ls.code-actions'),

    -- Terraform.
    null_ls.builtins.formatting.terrafmt,
    null_ls.builtins.formatting.terraform_fmt,

    -- JSON.
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.diagnostics.jsonlint,

    -- YAML.
    null_ls.builtins.diagnostics.yamllint.with({
      diagnostics_format = '[#{c}] #{m} (#{s})'
    }),

    -- XML.
    null_ls.builtins.formatting.xmllint,

    -- SQL.
    null_ls.builtins.formatting.sqlformat,

    -- OpenAPI.
    -- null_ls.builtins.diagnostics.vacuum,
    -- null_ls.builtins.diagnostics.spectral.with({
    --   dynamic_command = cmd_resolver.from_node_modules(),
    --   cwd = null_ls_helpers.cache.by_bufnr(function(params)
    --     return null_ls_utils.root_pattern('.spectral.yaml')(params.bufname)
    --   end),
    --   filetypes = { 'yaml.openapi', 'json.openapi' },
    --   condition = function(utils)
    --     return utils.root_has_file({ '.spectral.yaml' })
    --   end
    -- })
  }
})

vim.api.nvim_create_autocmd('BufReadPre', {
  desc = 'Set OpenAPI yaml file types',
  pattern = '*.openapi.yaml,*.openapi.yml',
  callback = function(data)
    vim.api.nvim_buf_set_option(data.buf, 'filetype', 'yaml.openapi')
  end,
  group = vim.api.nvim_create_augroup('NullLs.YAML.OpenAPI', {}),
})

vim.api.nvim_create_autocmd('BufReadPre', {
  desc = 'Set OpenAPI JSON file types',
  pattern = '*.openapi.json',
  callback = function(data)
    vim.api.nvim_buf_set_option(data.buf, 'filetype', 'yaml.json')
  end,
  group = vim.api.nvim_create_augroup('NullLs.JSON.OpenAPI', {}),
})

null_ls.register({
  name = 'more_actions',
  method = { null_ls.methods.CODE_ACTION },
  filetypes = { '_all' },
  generator = {
    fn = require('ts-node-action').available_actions
  }
})

mason_null_ls.setup({
  ensure_installed = {
    'actionlint',
    'autopep8',
    'cfn_lint',
    'eslint_d',
    'fixjson',
    'php',
    'phpcsfixer',
    'shellcheck',
    'shfmt',
    -- 'spectral',
    'sqlformat',
    'stylelint',
    'terrafmt',
    'terraform_fmt',
    'vacuum',
    'vint',
    'xmllint',
    'zsh',
  },
  automatic_installation = false,
  automatic_setup = false,
})
