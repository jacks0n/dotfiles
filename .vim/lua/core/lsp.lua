local lazydev = require('lazydev')
lazydev.setup({
  library = {
    vim.env.VIMRUNTIME,
    { path = 'luvit-meta/library', words = { 'vim%.uv' } },
  },
  runtime = vim.env.VIMRUNTIME,
  types = true,
  integrations = {
    lspconfig = true,
    cmp = false,
  },
})

local lspconfig = require('lspconfig')
local navbuddy = require('nvim-navbuddy')
local schemastore = require('schemastore')

vim.lsp.set_log_level('warn')

-- Setup Mason
require('mason').setup({
  ui = {
    border = 'rounded',
  },
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'vtsls',
    'basedpyright',
    'lua_ls',
    'jsonls',
    'yamlls',
    'jdtls',
    'vimls',
    'bashls',
    'cssls',
    'html',
    'dockerls',
    'terraformls',
    'marksman',
    'sqlls',
    'intelephense',
  },
  automatic_enable = true,
})

-- Setup capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Use blink.cmp's capabilities
local blink_capabilities = require('blink.cmp').get_lsp_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, blink_capabilities)

-- Common on_attach function
local function on_attach(client, buffer)
  -- Setup navbuddy
  if client.server_capabilities.documentSymbolProvider then
    navbuddy.attach(client, buffer)
  end

  -- Setup key mappings
  local opts = { noremap = true, silent = true, buffer = buffer }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, opts)
end

-- TypeScript/JavaScript shared configuration
local ts_js_settings = {
  preferences = {
    importModuleSpecifier = 'shortest',
    importModuleSpecifierEnding = 'auto',
    includePackageJsonAutoImports = 'auto',
    quotePreference = 'auto',
  },
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = 'all',
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  },
  suggest = {
    completeFunctionCalls = true,
    includeAutomaticOptionalChainCompletions = true,
    includeCompletionsForModuleExports = true,
    includeCompletionsForImportStatements = true,
    includeCompletionsWithInsertText = true,
  },
  updateImportsOnFileMove = {
    enabled = 'always',
  },
  codeActions = {
    disableRuleComment = {
      enable = true,
    },
  },
  experimental = {
    tsserver = {
      web = {
        enableProjectWideIntellisense = true,
      },
    },
  },
}

-- TypeScript/JavaScript
lspconfig.vtsls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  single_file_support = false,
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = ts_js_settings,
    javascript = ts_js_settings,
  },
})

-- Python
lspconfig.basedpyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  single_file_support = false,
  root_dir = lspconfig.util.root_pattern(
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git'
  ),
  on_new_config = function(config, root_dir)
    -- Detect Python path
    local python_path = nil

    -- Check for local virtual environments
    local venv_dirs = { '.venv', 'venv', 'env', '.env' }
    for _, vdir in ipairs(venv_dirs) do
      local venv_path = root_dir .. '/' .. vdir .. '/bin/python'
      if vim.fn.filereadable(venv_path) == 1 then
        python_path = venv_path
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
        local env_path = vim.env.VIRTUAL_ENV .. '/bin/python'
        if vim.fn.filereadable(env_path) == 1 then
          python_path = env_path
        end
      elseif vim.env.CONDA_PREFIX then
        local conda_path = vim.env.CONDA_PREFIX .. '/bin/python'
        if vim.fn.filereadable(conda_path) == 1 then
          python_path = conda_path
        end
      end
    end

    -- Default to system Python
    if not python_path then
      python_path = vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python3'
    end

    config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
      python = {
        pythonPath = python_path,
      },
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
          typeCheckingMode = 'standard',
          diagnosticSeverityOverrides = {
            reportGeneralTypeIssues = 'none',
            reportOptionalMemberAccess = 'none',
            reportOptionalSubscript = 'none',
            reportPrivateImportUsage = 'none',
          },
        },
      },
    })
  end,
})

-- Lua
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern('.luarc.json', '.luarc.jsonc', '.git'),
  single_file_support = true,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
        pathStrict = true,
      },
      diagnostics = {
        unusedLocalExclude = { '_*' },
        workspaceDelay = 3000,
        workspaceRate = 100,
      },
      completion = {
        callSnippet = 'Replace',
        workspaceWord = true,
        showWord = 'Enable',
      },
      workspace = {
        checkThirdParty = false,
        library = {},
        maxPreload = 10000,
        preloadFileSize = 1000,
        ignoreDir = {
          vim.o.undodir,
          vim.o.backupdir,
          'plugged',
          '.git',
          '.cache',
          'node_modules',
          '.vim/backup',
          '.vim/swap',
          '.vim/undo',
          '.vim/plugged',
        },
      },
      telemetry = {
        enable = false,
      },
      format = {
        enable = false,
      },
    },
  },
})

-- JSON
lspconfig.jsonls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = { provideFormatter = true },
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    },
  },
})

-- YAML
lspconfig.yamlls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    yaml = {
      hover = true,
      completion = true,
      validate = true,
      schemas = schemastore.json.schemas(),
      schemaStore = {
        enable = true,
      },
      customTags = {
        '!And sequence',
        '!And',
        '!Base64 scalar',
        '!Base64',
        '!Cidr scalar',
        '!Cidr sequence',
        '!Cidr',
        '!Condition scalar',
        '!Equals sequence',
        '!Equals',
        '!FindInMap sequence',
        '!FindInMap',
        '!GetAZs scalar',
        '!GetAZs',
        '!GetAtt scalar',
        '!GetAtt sequence',
        '!GetAtt',
        '!If sequence',
        '!If',
        '!ImportValue scalar',
        '!ImportValue sequence',
        '!ImportValue',
        '!Join sequence',
        '!Join',
        '!Not sequence',
        '!Not',
        '!Or sequence',
        '!Or',
        '!Ref scalar',
        '!Ref',
        '!Select sequence',
        '!Select',
        '!Split sequence',
        '!Split',
        '!Sub scalar',
        '!Sub sequence',
        '!Sub',
        '!Transform mapping',
      },
    },
  },
})

-- Java
lspconfig.jdtls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    java = {
      signatureHelp = { enabled = true },
    },
  },
})

-- Vim
lspconfig.vimls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = { isNeovim = true },
})

-- Simple servers
lspconfig.bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.dockerls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.terraformls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.marksman.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.sqlls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.intelephense.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Bun support - override Node.js runtime if enabled
if vim.g.use_bun and vim.fn.executable('bun') == 1 then
  local original_setup = lspconfig.util.on_setup
  lspconfig.util.on_setup = function(config)
    if config.cmd and config.cmd[1] and string.match(config.cmd[1], 'node') then
      config.cmd = vim.list_extend({ 'bun', 'run', '--bun' }, config.cmd)
    end
    return original_setup(config)
  end
end
