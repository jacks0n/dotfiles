local lsp = require('lsp-zero')
local null_ls = require('null-ls')
local null_opts = lsp.build_options('null-ls', {})

null_ls.setup({
  on_attach = function(client, bufnr) null_opts.on_attach(client, bufnr) end,
  should_attach = function(bufnr)
    local max_filesize = 1024 * 1024 -- 1MB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    return (ok and stats and stats.size > max_filesize)
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
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.prettierd,
    require('typescript.extensions.null-ls.code-actions'),
    -- Terraform.
    null_ls.builtins.formatting.terrafmt,
    null_ls.builtins.formatting.terraform_fmt,
    -- JSON.
    null_ls.builtins.formatting.fixjson,
    -- YAML.
    null_ls.builtins.diagnostics.yamllint.with({
      diagnostics_format = '[#{c}] #{m} (#{s})'
    }),
    -- XML.
    null_ls.builtins.formatting.xmllint,
    -- SQL.
    null_ls.builtins.formatting.sqlformat
  }
})

null_ls.register({
  name = 'more_actions',
  method = { null_ls.methods.CODE_ACTION },
  filetypes = { '_all' },
  generator = {
    fn = require('ts-node-action').available_actions
  }
})

require('mason-null-ls').setup({
  ensure_installed = nil,
  automatic_installation = true,
  automatic_setup = true
})
