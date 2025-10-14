local lazydev = require('lazydev')
local lspconfig_util = require('lspconfig.util')
local navbuddy = require('nvim-navbuddy')
local schemastore = require('schemastore')
local utils = require('core.utils')

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
    'omnisharp',
  },
  automatic_enable = false,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_capabilities = require('blink.cmp').get_lsp_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, blink_capabilities)

local telescope_builtin = require('telescope.builtin')
local telescope_util = require('plugins.telescope')
local telescope_actions = require('telescope.actions')
local telescope_actions_state = require('telescope.actions.state')

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
  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  -- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)

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
  vim.keymap.set(
    'n',
    '<Leader>b',
    telescope_util.call_telescope_vertical(telescope_builtin.buffers),
    { desc = 'LSP buffers' }
  )
  vim.keymap.set('n', '<C-t>', telescope_util.grep_project, { desc = 'Grep project' })
  vim.keymap.set('n', '<Leader>h', telescope_util.git_files_source, { desc = 'Git source files' })
  vim.keymap.set('n', '<C-g>', telescope_util.git_files_all, { desc = 'Git files (all)' })
  vim.keymap.set('n', '<Leader>gg', telescope_util.grep_project, { desc = 'Git grep in project' })
  vim.keymap.set('n', '<C-p>', telescope_builtin.commands, { desc = 'Commands' })
  vim.keymap.set('n', '<Leader>ls', telescope_util.find_symbol_project, { desc = 'Find symbol in project' })

  -- Project switching with configurable workspaces
  vim.keymap.set('n', '<Leader>p', function()
    local workspaces = vim.g.telescope_project_workspaces
    local dirs = {}

    -- Expand and collect all directories from workspaces.
    for _, workspace in ipairs(workspaces) do
      local expanded = vim.fn.expand(workspace)
      if vim.fn.isdirectory(expanded) == 1 then
        table.insert(dirs, expanded)
      end
    end

    if #dirs == 0 then
      vim.notify('No valid project workspaces found', vim.log.levels.WARN)
      return
    end

    -- Use Telescope to find directories in workspaces.
    telescope_builtin.find_files({
      search_dirs = dirs,
      prompt_title = 'Switch Project',
      layout_strategy = 'vertical',
      find_command = { 'fd', '--type', 'd', '--max-depth', '1' },
      attach_mappings = function(prompt_bufnr, map)
        telescope_actions.select_default:replace(function()
          telescope_actions.close(prompt_bufnr)
          local selection = telescope_actions_state.get_selected_entry()
          if selection then
            telescope_builtin.find_files({
              cwd = selection.value,
              layout_strategy = 'vertical',
            })
          end
        end)
        return true
      end,
    })
  end, { desc = 'Switch project' })
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

  basedpyright = {
    single_file_support = false,
    root_dir = lspconfig_util.root_pattern(
      -- @todo Setup for monorepos
      -- 'pyproject.toml',
      -- 'setup.py',
      -- 'setup.cfg',
      -- 'requirements.txt',
      -- 'Pipfile',
      -- 'pyrightconfig.json',
      '.git'
    ),
    on_new_config = function(config, root_dir)
      local python_path = utils.detect_python_path(root_dir)

      config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
        python = {
          pythonPath = python_path,
        },
        basedpyright = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = 'workspace',
            indexing = true,
            typeCheckingMode = 'standard',
            completeFunctionParens = true,
            autoImportCompletions = true,
            extraPaths = { root_dir },
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
  },

  lua_ls = {
    root_dir = lspconfig_util.root_pattern('.luarc.json', '.luarc.jsonc', '.git'),
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
    init_options = { provideFormatter = true },
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
        validate = { enable = true },
      },
    },
  },

  yamlls = {
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
    root_dir = lspconfig_util.root_pattern('*.sln', '*.csproj', 'omnisharp.json', 'function.json'),
    handlers = {
      ['textDocument/definition'] = require('omnisharp_extended').handler,
    },
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = true,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true,
        EnableImportCompletion = true,
        AnalyzeOpenDocumentsOnly = false,
      },
      Sdk = {
        IncludePrereleases = true,
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
    local new_config = vim.deepcopy(config)

    -- Convert lspconfig.util root_dir functions to new API format
    if type(new_config.root_dir) == 'function' then
      local old_root_dir = new_config.root_dir
      new_config.root_dir = function(bufnr, on_dir)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local root = old_root_dir(filename)
        on_dir(root)
      end
    end

    vim.lsp.config[server_name] = new_config
    vim.lsp.enable(server_name)
  end
-- Old API (Neovim 0.10 and below)
else
  local lspconfig = require('lspconfig')

  -- For root_dir functions that need lspconfig.util, we need to convert them
  for server_name, config in pairs(lsp_server_configs) do
    -- @todo Remove?
    -- local server_config = vim.deepcopy(config)
    -- lspconfig[server_name].setup(server_config)
    lspconfig[server_name].setup(config)
  end
end

-- Bun support - override Node.js runtime if enabled
if vim.g.use_bun and vim.fn.executable('bun') == 1 then
  if vim.lsp.config then
    -- New API: Override cmd for applicable servers
    for server_name, _config in pairs(lsp_server_configs) do
      if vim.lsp.config[server_name] and vim.lsp.config[server_name].cmd then
        local cmd = vim.lsp.config[server_name].cmd
        if cmd and cmd[1] and string.match(cmd[1], 'node') then
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
