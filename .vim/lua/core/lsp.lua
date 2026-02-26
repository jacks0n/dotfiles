local lazydev = require('lazydev')
local navbuddy = require('nvim-navbuddy')
local schemastore = require('schemastore')
local utils = require('core.utils')

-- Helper to create root_dir functions using the new API signature (bufnr, on_dir)
-- Searches upward from the buffer's file for the first matching marker
local function root_pattern(...)
  local patterns = { ... }
  return function(bufnr, on_dir)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fs.dirname(filename)
    local match = vim.fs.find(patterns, { upward = true, path = dir })[1]
    on_dir(match and vim.fs.dirname(match) or nil)
  end
end

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

vim.lsp.set_log_level('warn')

vim.lsp.config('*', {
  root_markers = { '.git' },
})

local lsp_servers = {
  vtsls = true,
  eslint = true,
  ruff = true,
  lua_ls = true,
  jsonls = true,
  yamlls = true,
  jdtls = true,
  vimls = true,
  bashls = true,
  cssls = true,
  html = true,
  dockerls = true,
  terraformls = true,
  marksman = true,
  sqlls = true,
  intelephense = true,
  -- omnisharp = true,
  -- Note: roslyn is configured below but not auto-installed via Mason
  -- ty = true,
  pyrefly = true,
  -- basedpyright = true,
}

require('mason-lspconfig').setup({
  ensure_installed = lsp_servers,
  automatic_enable = false,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_capabilities = require('blink.cmp').get_lsp_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, blink_capabilities)

local telescope_builtin = require('telescope.builtin')
local telescope_util = require('plugins.telescope')

-- Delete the defaults.
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grn')

local function on_attach_default(client, buffer)
  if client.server_capabilities.documentSymbolProvider then
    navbuddy.attach(client, buffer)
  end

  local opts = { noremap = true, silent = true, buffer = buffer }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, opts)

  vim.keymap.set(
    'n',
    'gr',
    telescope_util.call_telescope_vertical(telescope_builtin.lsp_references),
    { desc = 'LSP references' }
  )
  vim.keymap.set(
    'n',
    'gt',
    telescope_util.call_telescope_vertical(telescope_builtin.lsp_type_definitions),
    { desc = 'LSP type definition(s)' }
  )
  vim.keymap.set(
    'n',
    'gd',
    telescope_util.call_telescope_vertical(telescope_builtin.lsp_definitions),
    { desc = 'LSP definition(s)' }
  )
  vim.keymap.set(
    'n',
    'gi',
    telescope_util.call_telescope_vertical(telescope_builtin.lsp_implementations),
    { desc = 'LSP implementation(s)' }
  )
end

local python_root_patterns = { 'pyproject.toml', 'uv.lock', 'poetry.lock', 'requirements.txt', 'setup.py', 'setup.cfg', '.git' }

local function get_root_dir_from_params(params)
  local root_uri = params.rootUri or params.rootPath
  return root_uri and vim.uri_to_fname(root_uri) or nil
end

-- TypeScript/JavaScript shared configuration
local ts_js_settings = {
  preferences = {
    importModuleSpecifier = 'relative',
    importModuleSpecifierEnding = 'auto',
    includePackageJsonAutoImports = 'auto',
    includeCompletionsForModuleExports = true,
    includeCompletionsForImportStatements = true,
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
    includeCompletionsWithInsertText = true,
    paths = true,
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

local lsp_server_configs = {
  vtsls = {
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
  },

  eslint = {
    single_file_support = false,
    root_dir = root_pattern(
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.mjs',
      '.eslintrc.json',
      '.eslintrc.yaml',
      '.eslintrc.yml',
      'eslint.config.js',
      'eslint.config.cjs',
      'eslint.config.mjs',
      'package.json'
    ),
    settings = {
      format = false,
      useESLintClass = true,
    },
  },

  -- ty: Astral's fast Python type checker (Rust-based, incremental caching)
  -- Supports: workspace diagnostics, find references, workspace symbols
  -- Missing: call hierarchy (incoming/outgoing calls)
  ty = {
    capabilities = capabilities,
    filetypes = { 'python' },
    root_dir = root_pattern('ty.toml', unpack(python_root_patterns)),
    single_file_support = false,
    before_init = function(params, config)
      local root_dir = get_root_dir_from_params(params)
      if not root_dir then
        return
      end

      local python_settings = utils.detect_python_settings(root_dir)
      local extra_paths = utils.discover_python_extra_paths(root_dir, python_settings.pythonPath)

      local ty_config = {
        environment = {
          python = python_settings.pythonPath,
          ['extra-paths'] = extra_paths,
        },
      }

      config.settings = config.settings or {}
      config.settings.ty = config.settings.ty or {}
      config.settings.ty.configuration = vim.tbl_deep_extend('force', config.settings.ty.configuration or {}, ty_config)

      params.initializationOptions = vim.tbl_deep_extend('force', params.initializationOptions or {}, {
        configuration = ty_config,
      })
    end,
    on_init = function(client, _initialize_result)
      vim.schedule(function()
        client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
      end)
    end,
    settings = {
      ty = {
        configuration = {},
      },
    },
  },

  -- pyrefly: Meta's fast Python type checker (Rust-based)
  -- Supports: workspace diagnostics, find references, workspace symbols, call hierarchy (incoming/outgoing)
  pyrefly = {
    capabilities = capabilities,
    filetypes = { 'python' },
    root_dir = root_pattern(unpack(python_root_patterns)),
    single_file_support = false,
    before_init = function(params, config)
      local root_dir = get_root_dir_from_params(params)
      if not root_dir then
        return
      end

      local python_settings = utils.detect_python_settings(root_dir)
      local extra_paths = utils.discover_python_extra_paths(root_dir, python_settings.pythonPath)

      config.settings = config.settings or {}
      config.settings.python = vim.tbl_deep_extend('force', config.settings.python or {}, python_settings)
      config.settings.pyrefly = config.settings.pyrefly or {}
      config.settings.pyrefly.extraPaths = extra_paths

      params.initializationOptions = vim.tbl_deep_extend('force', params.initializationOptions or {}, {
        pythonPath = python_settings.pythonPath,
        pyrefly = {
          extraPaths = extra_paths,
        },
      })
    end,
    on_init = function(client, _initialize_result)
      vim.schedule(function()
        client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
      end)
    end,
    settings = {
      python = {},
      pyrefly = {
        extraPaths = {},
      },
    },
  },

  ruff = {
    single_file_support = false,
    filetypes = { 'python' },
    root_dir = root_pattern('pyproject.toml', 'ruff.toml', '.ruff.toml', '.git'),
    init_options = {
      settings = {
        organizeImports = true,
        fixAll = true,
      },
    },
  },

  -- basedpyright: Pyright fork with additional features (slow, no persistent index cache)
  -- Supports: all features including call hierarchy
  basedpyright = {
    capabilities = capabilities,
    single_file_support = false,
    filetypes = { 'python' },
    root_dir = root_pattern(unpack(python_root_patterns)),
    before_init = function(params, config)
      local root_dir = get_root_dir_from_params(params)
      if not root_dir then
        return
      end

      local python_settings = utils.detect_python_settings(root_dir)
      local extra_paths = utils.discover_python_extra_paths(root_dir, python_settings.pythonPath)

      config.settings = config.settings or {}
      config.settings.python = vim.tbl_deep_extend('force', config.settings.python or {}, python_settings)
      config.settings.basedpyright = config.settings.basedpyright or {}
      config.settings.basedpyright.analysis = vim.tbl_deep_extend('force', config.settings.basedpyright.analysis or {}, {
        extraPaths = extra_paths,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
        indexing = true,
        typeCheckingMode = 'strict',
        completeFunctionParens = true,
        autoImportCompletions = true,
      })

      params.initializationOptions = vim.tbl_deep_extend('force', params.initializationOptions or {}, {
        python = python_settings,
        basedpyright = { analysis = { extraPaths = extra_paths } },
      })
    end,
    on_init = function(client, _initialize_result)
      vim.schedule(function()
        client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
      end)
    end,
    settings = {
      python = {},
      basedpyright = {
        analysis = {
          extraPaths = {},
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
          indexing = true,
          typeCheckingMode = 'strict',
          completeFunctionParens = true,
          autoImportCompletions = true,
        },
      },
    },
  },

  lua_ls = {
    root_dir = root_pattern('.luarc.json', '.luarc.jsonc', '.git'),
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
  },

  jsonls = {
    init_options = { provideFormatter = false },
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
        validate = { enable = true },
      },
    },
  },

  -- yamlls = {
  --   settings = {
  --     yaml = {
  --       hover = true,
  --       completion = true,
  --       validate = true,
  --       schemas = schemastore.json.schemas(),
  --       customTags = {
  --         '!And sequence',
  --         '!And',
  --         '!Base64 scalar',
  --         '!Base64',
  --         '!Cidr scalar',
  --         '!Cidr sequence',
  --         '!Cidr',
  --         '!Condition scalar',
  --         '!Contains scalar',
  --         '!Contains sequence',
  --         '!Contains',
  --         '!Equals sequence',
  --         '!Equals',
  --         '!FindInMap sequence',
  --         '!FindInMap',
  --         '!ForEach mapping',
  --         '!ForEach',
  --         '!GetAZs scalar',
  --         '!GetAZs',
  --         '!GetAtt scalar',
  --         '!GetAtt sequence',
  --         '!GetAtt',
  --         '!If sequence',
  --         '!If',
  --         '!ImportValue scalar',
  --         '!ImportValue sequence',
  --         '!ImportValue',
  --         '!Join sequence',
  --         '!Join',
  --         '!Length scalar',
  --         '!Length sequence',
  --         '!Length',
  --         '!Not sequence',
  --         '!Not',
  --         '!Or sequence',
  --         '!Or',
  --         '!Ref scalar',
  --         '!Ref',
  --         '!Select sequence',
  --         '!Select',
  --         '!Split sequence',
  --         '!Split',
  --         '!Sub scalar',
  --         '!Sub sequence',
  --         '!Sub',
  --         '!ToJsonString scalar',
  --         '!ToJsonString mapping',
  --         '!ToJsonString sequence',
  --         '!ToJsonString',
  --         '!Transform mapping',
  --       },
  --     },
  --   },
  -- },

  cfn_lsp_extra = {
    filetypes = { 'yaml.cloudformation', 'json.cloudformation' },
    root_dir = root_pattern('.git'),
    settings = {
      documentFormatting = false,
    },
  },

  jdtls = {
    settings = {
      java = {
        signatureHelp = { enabled = true },
      },
    },
  },

  vimls = {
    init_options = { isNeovim = true },
  },

  omnisharp = {
    root_dir = root_pattern('*.csproj', '*.sln', 'omnisharp.json', 'postsharp.config', 'Web.config'),
    handlers = (function()
      local omnisharp_extended = require('omnisharp_extended')
      return {
        ['textDocument/definition'] = omnisharp_extended.definition_handler,
        ['textDocument/typeDefinition'] = omnisharp_extended.type_definition_handler,
        ['textDocument/references'] = omnisharp_extended.references_handler,
        ['textDocument/implementation'] = omnisharp_extended.implementation_handler,
      }
    end)(),
    enable_editorconfig_support = true,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = true,
      },
      MsBuild = {
        LoadProjectsOnDemand = false,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true,
        EnableImportCompletion = true,
        AnalyzeOpenDocumentsOnly = false,
        EnableDecompilationSupport = true,
      },
      Sdk = {
        IncludePrereleases = true,
      },
    },
    on_attach = function(client, _bufnr)
      if client.server_capabilities.semanticTokensProvider then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end,
  },

  -- Let roslyn.nvim handle this
  roslyn = {
    root_dir = root_pattern('*.sln', '*.csproj'),
    filetypes = { 'cs', 'vb' },
    settings = {
      broad_search = true,
      ['csharp|inlay_hints'] = {
        csharp_enable_inlay_hints_for_implicit_object_creation = true,
        csharp_enable_inlay_hints_for_implicit_variable_types = true,
        csharp_enable_inlay_hints_for_lambda_parameter_types = true,
        csharp_enable_inlay_hints_for_types = true,
        dotnet_enable_inlay_hints_for_indexer_parameters = true,
        dotnet_enable_inlay_hints_for_literal_parameters = true,
        dotnet_enable_inlay_hints_for_object_creation_parameters = true,
        dotnet_enable_inlay_hints_for_other_parameters = true,
        dotnet_enable_inlay_hints_for_parameters = true,
        dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
        dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
        dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
      },
      ['csharp|code_lens'] = {
        dotnet_enable_references_code_lens = true,
        dotnet_enable_tests_code_lens = true,
      },
      ['csharp|completion'] = {
        dotnet_provide_regex_completions = true,
        dotnet_show_completion_items_from_unimported_namespaces = true,
        dotnet_show_name_completion_suggestions = true,
      },
      ['csharp|formatting'] = {
        dotnet_organize_imports_on_format = true,
      },
    },
  },

  bashls = {},
  cssls = {},
  html = {},
  dockerls = {},
  terraformls = {},
  marksman = {},
  sqlls = {},
  intelephense = {},
}

for _server_name, config in pairs(lsp_server_configs) do
  local original_on_attach = config.on_attach
  config.on_attach = function(client, buffer)
    on_attach_default(client, buffer)
    if original_on_attach then
      original_on_attach(client, buffer)
    end
  end
  config.capabilities = config.capabilities or capabilities
end

-- New API (Neovim 0.11+)
if vim.lsp.config then
  for server_name, config in pairs(lsp_server_configs) do
    if lsp_servers[server_name] then
      vim.lsp.config[server_name] = config
      vim.lsp.enable(server_name)
    end
  end
-- Old API (Neovim 0.10 and below)
else
  local lspconfig = require('lspconfig')

  for server_name, config in pairs(lsp_server_configs) do
    if lsp_servers[server_name] then
      local lspconfig_config = vim.deepcopy(config)
      if type(lspconfig_config.root_dir) == 'function' then
        local new_root_dir = lspconfig_config.root_dir
        lspconfig_config.root_dir = function(filename)
          local result
          new_root_dir(vim.fn.bufnr(filename), function(root)
            result = root
          end)
          return result
        end
      end
      lspconfig[server_name].setup(lspconfig_config)
    end
  end
end

-- Bun support - override Node.js runtime if enabled
if vim.g.use_bun and vim.fn.executable('bun') == 1 then
  if vim.lsp.config then
    -- New API: Override cmd for applicable servers
    for server_name, _config in pairs(lsp_server_configs) do
      if vim.lsp.config[server_name] and vim.lsp.config[server_name].cmd then
        local cmd = vim.lsp.config[server_name].cmd
        if type(cmd) == 'table' and cmd[1] and string.match(cmd[1], 'node') then
          vim.lsp.config[server_name].cmd = vim.list_extend({ 'bun', 'run', '--bun' }, cmd)
        end
      end
    end
  else
    -- Old API: Use the original method
    local lspconfig = require('lspconfig')
    local original_setup = lspconfig.util.on_setup
    lspconfig.util.on_setup = function(config)
      if config.cmd and config.cmd[1] and string.match(config.cmd[1], 'node') then
        config.cmd = vim.list_extend({ 'bun', 'run', '--bun' }, config.cmd)
      end
      return original_setup(config)
    end
  end
end

-- Export for use in plugin configs
return {
  on_attach_default = on_attach_default,
  lsp_servers = vim.tbl_keys(lsp_servers),
}
