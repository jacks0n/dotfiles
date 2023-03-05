local lsp = require('lsp-zero')

vim.lsp.set_log_level('error')

require('mason.settings').set({
  ui = {
    border = 'rounded',
  },
})

lsp.preset({
  set_lsp_keymaps = false,
  cmp_capabilities = true,
  manage_nvim_cmp = false,
  suggest_lsp_servers = false,
  configure_diagnostics = false,
  call_servers = 'local',
  sign_icons = {
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '',
  },
})

lsp.ensure_installed({
  'bashls',
  'cssls',
  'cucumber_language_server',
  'diagnosticls',
  'docker_compose_language_service',
  'dockerls',
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
  'tsserver',
  'vimls',
  'yamlls',
  -- "vtsls",
  -- Doesn't show function documentaiion.
  -- 'jedi_language_server',
  -- 'pylsp',
  -- 'pyright',
  -- 'sourcery',
})

lsp.skip_server_setup({ 'diagnostic-languageserver', 'eslint', 'diagnosticls', 'shellcheck', 'bashls' })

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
          [vim.api.nvim_get_runtime_file('lua', true)] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
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

lsp.configure('pyright', {
  settings = {
    pyright = {
      autoImportCompletion = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'off',
      },
    },
  },
})

lsp.configure('sourcery', {
  init_options = {
    editor_version = 'vim',
    extension_version = 'vim.lsp',
    token = os.getenv('SOURCERY_TOKEN'),
  },
})

lsp.configure('vimls', {
  init_options = { isNeovim = true },
})

local tsserver_lang_config = {
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  },
}
lsp.configure('tsserver', {
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  -- @see https://github.com/typescript-language-server/typescript-language-server#initializationoptions
  settings = {
    typescript = tsserver_lang_config,
    javascript = tsserver_lang_config,
    implicitProjectConfig = {
      checkJs = true,
      enableImplicitProjectConfig = true,
    },
    completions = {
      completeFunctionCalls = true,
    },
    format = {
      indentSize = 2,
      tabSize = 2,
    },
  },
})


-- lsp.on_attach(function(client, bufnr)
--   client.server_capabilities.documentFormattingProvider = true
--   client.server_capabilities.documentFormattingRangeProvider = true
--   if client.supports_method('textDocument/formatting') then
--     vim.api.nvim_create_autocmd('BufWritePre', {
--       group = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, {}),
--       buffer = bufnr,
--       callback = function()
--         vim.lsp.buf.format()
--       end,
--     })
--   end
-- end)

if vim.g.use_bun then
  local lspconfig = require('lspconfig')
  lspconfig.util.on_setup = lspconfig.util.add_hook_after(lspconfig.util.on_setup, function(config)
    local incompatible_servers = {
      diagnosticls = true,
      jsonls = true,
      graphql = true,
      vimls = true,
      vtsls = true,
      eslint = true,
      lua_ls = true,
    }
    if incompatible_servers[config.name] ~= nil then
      -- vim.notify(string.format('Not using Bun for incompatible client: %s', config.name), vim.log.levels.INFO)
      return
    end

    if config.cmd[1] == 'node' then
      -- vim.notify(string.format('Using bun for client: %s', config.name), vim.log.levels.INFO)
      config.cmd[1] = 'bun'
    else
      local cmd_handle = io.popen('which ' .. config.cmd[1])
      if not cmd_handle then
        -- vim.notify(string.format('Error checking lsp client path "%s"', config.name), vim.log.levels.ERROR)
        return
      end
      local cmd_path = string.gsub(cmd_handle:read('*a'), '%s+', '')
      if not cmd_path then
        -- vim.notify(string.format('Error checking lsp client "%s" file', config.name), vim.log.levels.ERROR)
        return
      end
      cmd_handle:close()

      local cmd_file = io.open(cmd_path)
      if not cmd_file then
        -- vim.notify(string.format('Error reading lsp client "%s" file', cmd_path), vim.log.levels.ERROR)
        return
      end
      for l in cmd_file:lines() do
        if string.sub(l, -4) == 'node' then
          -- vim.notify(string.format('Using bun for client: %s', config.name), vim.log.levels.INFO)
          config.cmd[1] = cmd_path
          table.insert(config.cmd, 1, 'bun')
        end
      end
    end
  end)
end

lsp.setup()
