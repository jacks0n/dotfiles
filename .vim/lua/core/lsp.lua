local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')
-- local error_lens = require('error-lens')
local lspconfig_util = require('lspconfig/util')
local navbuddy = require('nvim-navbuddy')

-- require('lspconfig.configs').vtsls = require('vtsls').lspconfig

require('neodev').setup()

vim.lsp.set_log_level('info')

require('mason.settings').set({
  ui = {
    border = 'rounded',
  },
})

lsp.preset({
  set_lsp_keymaps = false,
  manage_nvim_cmp = false,
  configure_diagnostics = false,
  call_servers = 'local',
})

lsp.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = ''
})

lsp.ensure_installed({
  'bashls',
  'cssls',
  'cucumber_language_server',
  'diagnosticls',
  'docker_compose_language_service',
  'dockerls',
  'eslint',
  'html',
  'intelephense',
  'jsonls',
  'lemminx',
  'lua_ls',
  'marksman',
  'phpactor',
  'psalm',
  'sqlls',
  'terraformls',
  'tflint',
  -- 'tsserver',
  'vimls',
  'yamlls',
  'jdtls',
  -- Python.
  'pyright',
  'pylsp',
  'jedi_language_server',
  -- 'vtsls',
  -- 'sourcery',
})

lsp.skip_server_setup({
  'diagnostic-languageserver',
  'diagnosticls',
  'shellcheck',
  'bashls',
  'prettier',
  'sourcery',
  'vtsls',
  -- 'tsserver',
  -- 'typescript-language-server'
})

lsp.configure('jdtls', {
  settings = {
    java = {
      signatureHelp = {
        enabled = true
      },
    }
  }
})

lsp.configure('pyright', {
  single_file_support = false, -- ?
  on_attach = function(client, bufnr)
    local util = require('lspconfig/util')
    local path = util.path
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local repo_root = lspconfig_util.root_pattern(
      'setup.py', 'setup.cfg', 'requirements.txt',
      '.venv', '.virtualenv', 'pyproject.toml', '.git'
    )(filename)

    local function get_python_path()
      -- Use activated virtualenv.
      if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
      end

      -- Fallback to system Python.
      return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
    end

    client.config.settings.python.pythonPath = get_python_path()

    -- Path to a directory containing one or more subdirectories, each of which contains a virtual environment.
    local venv_dir = lspconfig_util.root_pattern('.venv', '.virtualenv')(filename)
    if venv_dir then
      client.config.settings.venvPath = path.join(venv_dir, 'bin', 'python')
    end

    -- Used in conjunction with the venvPath, specifies the virtual environment to use.
    if vim.env.VENV_ROOT then
      client.config.settings.venv = vim.env.VENV_ROOT -- Defined in ~/.shrc.local
    end
  end,
  filetypes = { 'python' },
  -- root_dir = function(filename)
  --   return lspconfig_util.root_pattern('setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt', '.git')(filename) or
  --   lspconfig_util.path.dirname(filename);
  -- end,
  settings = {
    defaultVenv = { '.venv' },
    pyright = {
      disableOrganizeImports = false,
      autoImportCompletions = true,
    },
    python = {
      -- pythonPath = '/Users/jackson/Code/bom/aviation-message-broker/.venv/bin/python',
      -- venvPath = '/Users/jackson/Code/bom/aviation-message-broker/.venv',
      venvPath = '.venv',
      -- venv = '.',
      analysis = {
        extraPaths = {
          '.',
          '/users/jackson/code/bom/aviation-message-broker/tests',
          '/users/jackson/code/bom/aviation-message-broker/src',
        },
        completeFunctionParens = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
        typeCheckingMode = 'on',
        diagnosticSeverityOverrides = {
          reportGeneralTypeIssues = 'none',
        },
      },
    },
  },
})

lsp.configure('jsonls', {
  filetypes = { 'json', 'jsonc' },
  init_options = { provideFormatter = true },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = {
        enable = true,
      },
      configure = {
        allowComments = true,
      },
    },
  },
})

local lua_runtime_paths = vim.split(package.path, ';')
table.insert(lua_runtime_paths, 'lua/?.lua')
table.insert(lua_runtime_paths, 'lua/?/init.lua')
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
        unusedLocalExclude = { '_*' },
      },
      completion = {
        callSnippet = 'Replace',
      },
      workspace = {
        library = {
          vim.api.nvim_get_runtime_file('lua', true),
          vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
        },
        checkThirdParty = false,
        ignoreDir = {
          vim.o.undodir,
          vim.o.backupdir,
          'plugged',
          '.git',
          '.cache',
        },
      },
      telemetry = {
        enable = true,
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
        },
      },
    },
  },
})

lsp.configure('yamlls', {
  settings = {
    yaml = {
      hover = true,
      completion = true,
      validate = true,
      schemas = require('schemastore').json.schemas(),
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
})

lsp.configure('vimls', {
  init_options = { isNeovim = true },
})

local tsserver_lang_config = {
  preferences = {
    importModuleSpecifier = 'non-relative',
  },
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  },
  suggest = {
    completeFunctionCalls = true,
    includeAutomaticOptionalChainCompletions = true,
  },
  updateImportsOnFileMove = {
    enabled = 'always',
  },
  -- @todo Is this needed? What does it do?
  experimental = {
    tsserver = {
      web = {
        enableProjectWideIntellisense = true,
      },
    },
  },
}
-- lsp.configure('tsserver', {
--   filetypes = {
--     'javascript',
--     'javascriptreact',
--     'javascript.jsx',
--     'typescript',
--     'typescriptreact',
--     'typescript.tsx',
--     'typescriptreact.typescript',
--   },
--   commands = {
--     OrganizeImports = {
--       function()
--         vim.lsp.buf.execute_command({
--           command = '_typescript.organizeImports',
--           arguments = { vim.fn.expand('%:p') },
--         })
--       end,
--       description = 'Organize Imports'
--     }
--   },
--   -- @see https://github.com/typescript-language-server/typescript-language-server#initializationoptions
--   -- @see https://code.visualstudio.com/docs/getstarted/settings
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
--     format = {
--       indentSize = 2,
--       tabSize = 2,
--     },
--   },
-- })

lsp.on_attach(function(client, buffer)
  if client.server_capabilities.documentSymbolProvider then
    navbuddy.attach(client, buffer)
  end

  -- Let eslint handle formatting.
  if client.name == 'vtsls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentFormattingRangeProvider = false
  else
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentFormattingRangeProvider = true
  end

  -- error_lens.setup(client)
end)

if vim.g.use_bun then
  lspconfig.util.on_setup = lspconfig.util.add_hook_after(lspconfig.util.on_setup, function(config)
    if config.cmd[1] == 'node' then
      config.cmd = vim.list_extend({ 'bun', 'run', '--bun' }, config.cmd)
    else
      local cmd_handle = io.popen('which ' .. config.cmd[1])
      if not cmd_handle then
        return
      end
      local cmd_path = string.gsub(cmd_handle:read('*a'), '%s+', '')
      if not cmd_path then
        return
      end
      cmd_handle:close()

      local cmd_file = io.open(cmd_path)
      if not cmd_file then
        return
      end
      for l in cmd_file:lines() do
        if string.sub(l, -4) == 'node' then
          config.cmd[1] = cmd_path
          table.insert(config.cmd, 1, 'bun run --bun')
        end
      end
    end
  end)
end

lsp.setup()

local registry = require('mason-registry')
registry.refresh(function ()
  registry.get_package('lua-language-server')
end)
