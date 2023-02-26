require('mason-null-ls').setup({
  ensure_installed = {
    'hadolint',
    'eslint_d',
    'prettierd',
    'fixjson',
    'jq',
    'markdownlint',
    'phpcbf',
    'psalm',
    -- 'autopep8',
    'shellcheck',
    -- require('typescript.extensions.null-ls.code-actions'),
  },
  automatic_installation = true,
  automatic_setup = true,
})
