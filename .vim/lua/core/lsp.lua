local lspconfig = require('lspconfig')
local navbuddy = require('nvim-navbuddy')

require('plugins.lazydev')

vim.lsp.set_log_level('warn')

require('mason').setup({
  ui = {
    border = 'rounded',
  },
})

require('mason-lspconfig').setup()

-- Set up capabilities for nvim-cmp
local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = vim.tbl_deep_extend('force', lsp_capabilities, cmp_capabilities)

-- TypeScript/JavaScript language server configuration
local tsserver_lang_config = {
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

local on_attach = function(client, buffer)
  if client.server_capabilities.documentSymbolProvider then
    navbuddy.attach(client, buffer)
  end

  -- Let eslint handle formatting for TypeScript
  -- Commented out since we're using typescript-tools.nvim
  -- if client.name == 'ts_ls' or client.name == 'vtsls' then
  --   client.server_capabilities.documentFormattingProvider = false
  --   client.server_capabilities.documentFormattingRangeProvider = false
  -- end

  -- Set up LSP key mappings (diagnostic keymaps are in core.diagnostic)
  local opts = { noremap = true, silent = true, buffer = buffer }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- Use Telescope mapping instead
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

  -- Manually trigger signature help (useful when auto-trigger doesn't work)
  vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, opts)
end

-- Setup typescript-tools.nvim (replaces ts_ls)
require('typescript-tools').setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    expose_as_code_action = 'all',
    complete_function_calls = true,
    include_completions_with_insert_text = true,
    tsserver_file_preferences = vim.tbl_extend(
      'force',
      tsserver_lang_config.preferences or {},
      tsserver_lang_config.inlayHints or {},
      tsserver_lang_config.suggest or {},
      {
        updateImportsOnFileMove = tsserver_lang_config.updateImportsOnFileMove,
      }
    ),
    tsserver_format_options = {
      allowIncompleteCompletions = true,
      allowRenameOfImportPath = true,
    },
    jsx_close_tag = {
      enable = true,
      filetypes = { 'javascriptreact', 'typescriptreact' },
    },
  },
})

-- Lazy load LSP servers based on filetype
local lsp_configs = {
  jdtls = {
    filetypes = { 'java' },
    settings = {
      java = {
        signatureHelp = {
          enabled = true,
        },
      },
    },
  },
  jsonls = {
    filetypes = { 'json', 'jsonc' },
    init_options = { provideFormatter = true },
    settings = {
      json = {
        schemas = function()
          return require('schemastore').json.schemas()
        end,
        validate = {
          enable = true,
        },
        configure = {
          allowComments = true,
        },
      },
    },
  },
  lua_ls = {
    filetypes = { 'lua' },
    root_dir = require('lspconfig.util').root_pattern('.luarc.json', '.luarc.jsonc', '.git'),
    single_file_support = true,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
          pathStrict = true,
        },
        diagnostics = {
          globals = { 'vim' }, -- Lazydev should handle this, but adding as fallback
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
          library = {}, -- Let lazydev handle this completely
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
  yamlls = {
    filetypes = { 'yaml', 'yml' },
    settings = {
      yaml = {
        hover = true,
        completion = true,
        validate = true,
        schemas = function()
          return require('schemastore').json.schemas()
        end,
        schemastore = {
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
  },
  vimls = {
    filetypes = { 'vim' },
    init_options = { isNeovim = true },
  },
  -- Commented out in favor of typescript-tools.nvim
  -- ts_ls = {
  --   filetypes = {
  --     'javascript',
  --     'javascriptreact',
  --     'javascript.jsx',
  --     'typescript',
  --     'typescriptreact',
  --     'typescript.tsx',
  --     'typescriptreact.typescript',
  --   },
  --   settings = {
  --     typescript = tsserver_lang_config,
  --     javascript = tsserver_lang_config,
  --     implicitProjectConfig = {
  --       checkJs = true,
  --       enableImplicitProjectConfig = true,
  --     },
  --     completions = {
  --       completeFunctionCalls = true,
  --     },
  --   },
  -- },
}

-- Setup function for LSP servers
local function setup_lsp_server(server_name)
  local config = lsp_configs[server_name] or {}
  config.on_attach = on_attach
  config.capabilities = capabilities

  -- Resolve functions in settings
  if config.settings then
    local function resolve_functions(tbl)
      for k, v in pairs(tbl) do
        if type(v) == 'function' then
          tbl[k] = v()
        elseif type(v) == 'table' then
          resolve_functions(v)
        end
      end
    end
    resolve_functions(config.settings)
  end

  lspconfig[server_name].setup(config)
end

-- Create autocmds for lazy loading LSP servers
for server_name, config in pairs(lsp_configs) do
  if config.filetypes then
    vim.api.nvim_create_autocmd('FileType', {
      pattern = config.filetypes,
      once = true,
      callback = function()
        setup_lsp_server(server_name)
      end,
    })
  end
end

-- Cache for Python environment detection
local python_env_cache = {}

-- Function to detect Poetry virtual environment (async)
local function get_poetry_venv_path_async(callback)
  local cwd = vim.fn.getcwd()

  -- Check cache first
  if python_env_cache[cwd] and python_env_cache[cwd].poetry_venv then
    callback(python_env_cache[cwd].poetry_venv)
    return
  end

  vim.fn.jobstart({ 'poetry', 'env', 'info', '--path' }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and data[1] and data[1]:match('^/') then
        local venv_path = data[1]:gsub('%s+', '')
        python_env_cache[cwd] = python_env_cache[cwd] or {}
        python_env_cache[cwd].poetry_venv = venv_path
        callback(venv_path)
      else
        callback(nil)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        callback(nil)
      end
    end,
  })
end

-- Function to detect Python interpreter path (async)
local function get_python_path_async(callback)
  local cwd = vim.fn.getcwd()

  -- Check cache first
  if python_env_cache[cwd] and python_env_cache[cwd].python_path then
    callback(python_env_cache[cwd].python_path)
    return
  end

  -- Try Poetry first
  get_poetry_venv_path_async(function(poetry_venv)
    if poetry_venv then
      local python_path = poetry_venv .. '/bin/python'
      python_env_cache[cwd] = python_env_cache[cwd] or {}
      python_env_cache[cwd].python_path = python_path
      callback(python_path)
    else
      -- Fall back to pipenv
      vim.fn.jobstart({ 'pipenv', '--venv' }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data and data[1] and data[1]:match('^/') then
            local python_path = data[1]:gsub('%s+', '') .. '/bin/python'
            python_env_cache[cwd] = python_env_cache[cwd] or {}
            python_env_cache[cwd].python_path = python_path
            callback(python_path)
          else
            -- Fall back to system python
            callback('python3')
          end
        end,
        on_exit = function(_, exit_code)
          if exit_code ~= 0 then
            -- Fall back to system python
            callback('python3')
          end
        end,
      })
    end
  end)
end

-- Function to get project root and set appropriate paths (deferred)
local function setup_python_lsp()
  local root_dir = vim.fn.getcwd()

  -- Base paths for Python analysis
  local extra_paths = { '.' }

  -- Add common Python project paths
  local common_paths = { 'src', 'tests', 'lib' }
  for _, path in ipairs(common_paths) do
    local full_path = root_dir .. '/' .. path
    if vim.fn.isdirectory(full_path) == 1 then
      table.insert(extra_paths, full_path)
    end
  end

  -- Default settings (will be updated async)
  local python_settings = {
    python_path = 'python3',
    venv_path = '.venv',
    extra_paths = extra_paths,
  }

  -- Setup basedpyright with default settings first
  lspconfig.basedpyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    single_file_support = false,
    filetypes = { 'python' },
    settings = {
      python = {
        pythonPath = python_settings.python_path,
        venvPath = python_settings.venv_path,
      },
      basedpyright = {
        analysis = {
          extraPaths = python_settings.extra_paths,
          completeFunctionParens = true,
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
          typeCheckingMode = 'off',
          diagnosticSeverityOverrides = {
            reportGeneralTypeIssues = 'none',
            reportOptionalMemberAccess = 'none',
            reportOptionalSubscript = 'none',
            reportPrivateImportUsage = 'none',
          },
        },
        disableOrganizeImports = false,
        autoImportCompletions = true,
      },
    },
  })

  -- Update Python path asynchronously after initial setup
  get_python_path_async(function(python_path)
    get_poetry_venv_path_async(function(poetry_venv)
      -- Update settings with actual paths
      python_settings.python_path = python_path
      python_settings.venv_path = poetry_venv or '.venv'

      -- Add Poetry venv site-packages if available
      if poetry_venv then
        local site_packages = poetry_venv .. '/lib/python*/site-packages'
        local globbed = vim.fn.glob(site_packages)
        if globbed and globbed ~= '' then
          table.insert(python_settings.extra_paths, globbed)
        end
      end

      -- Update basedpyright config if it's already attached to buffers
      local clients = vim.lsp.get_clients({ name = 'basedpyright' })
      for _, client in ipairs(clients) do
        if client.config.settings then
          client.config.settings.python = client.config.settings.python or {}
          client.config.settings.python.pythonPath = python_settings.python_path
          client.config.settings.python.venvPath = python_settings.venv_path
          if client.config.settings.basedpyright and client.config.settings.basedpyright.analysis then
            client.config.settings.basedpyright.analysis.extraPaths = python_settings.extra_paths
          end
          client:notify('workspace/didChangeConfiguration', {
            settings = client.config.settings,
          })
        end
      end
    end)
  end)
end

-- Python LSP will be set up on demand
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  once = true,
  callback = function()
    setup_python_lsp()
  end,
})

-- Setup basic LSP servers from Mason on demand
local basic_servers = {
  bashls = { 'sh', 'bash' },
  cssls = { 'css', 'scss', 'less' },
  html = { 'html' },
  dockerls = { 'dockerfile' },
  terraformls = { 'terraform', 'tf' },
  marksman = { 'markdown' },
  sqlls = { 'sql' },
  intelephense = { 'php' },
}

for server, filetypes in pairs(basic_servers) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = filetypes,
    once = true,
    callback = function()
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
  })
end

-- Bun support - intercept LSP configs to use bun instead of node
if vim.g.use_bun then
  local original_setup = lspconfig.util.on_setup
  lspconfig.util.on_setup = function(config)
    if config.cmd and config.cmd[1] == 'node' then
      config.cmd = vim.list_extend({ 'bun', 'run', '--bun' }, config.cmd)
    elseif config.cmd then
      local cmd_handle = io.popen('which ' .. config.cmd[1])
      if cmd_handle then
        local cmd_path = string.gsub(cmd_handle:read('*a'), '%s+', '')
        cmd_handle:close()
        if cmd_path and cmd_path ~= '' then
          local cmd_file = io.open(cmd_path)
          if cmd_file then
            for line in cmd_file:lines() do
              if string.sub(line, -4) == 'node' then
                config.cmd[1] = cmd_path
                table.insert(config.cmd, 1, 'bun')
                table.insert(config.cmd, 2, 'run')
                table.insert(config.cmd, 3, '--bun')
                break
              end
            end
            cmd_file:close()
          end
        end
      end
    end
    return original_setup(config)
  end
end
