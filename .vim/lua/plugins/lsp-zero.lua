local lsp = require('lsp-zero')

require('mason.settings').set({
  ui = {
    border = 'rounded'
  }
})

lsp.preset('recommended')

lsp.set_preferences({
  set_lsp_keymaps = false,
  manage_nvim_cmp = false
})

-- vim.lsp.set_log_level('trace')

local util = require('lspconfig.util')

---@param opts table|nil
-- local function create_capabilities(opts)
--   local default_opts = {
--   with_snippet_support = true,
--   }
--   opts = opts or default_opts
--   local capabilities = vim.lsp.protocol.make_client_capabilities()
--   capabilities.textDocument.completion.completionItem.snippetSupport = opts.with_snippet_support
--   if opts.with_snippet_support then
--   capabilities.textDocument.completion.completionItem.resolveSupport = {
--     properties = {
--     'documentation',
--     'detail',
--     'additionalTextEdits',
--     },
--   }
--   end
--   return cmp_nvim_lsp.default_capabilities(capabilities)
-- end

-- util.on_setup = util.add_hook_after(util.on_setup, function(config)
--   config.capabilities = create_capabilities()
-- end)

lsp.configure('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
})

lsp.configure('sumneko_lua', {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim).
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global.
        globals = { vim = vim },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files.
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomised but unique identifier.
      telemetry = {
        enable = false,
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
        }
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
      customTags = {
        '!Base64 scalar',
        '!Cidr scalar',
        '!And sequence',
        '!Equals sequence',
        '!If sequence',
        '!Not sequence',
        '!Or sequence',
        '!Condition scalar',
        '!FindInMap sequence',
        '!GetAtt sequence',
        '!GetAtt scalar',
        '!GetAZs scalar',
        '!ImportValue scalar',
        '!Join sequence',
        '!Select sequence',
        '!Split sequence',
        '!Sub scalar',
        '!Transform mapping',
        '!Ref scalar',
      }
    },
  },
})

lsp.configure('pyright', {
  settings = {
    pyright = {
      autoImportCompletion = true
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'off'
      }
    }
  }
})

lsp.configure('sourcery', {
  init_options = {
    editor_version = 'vim',
    extension_version = 'vim.lsp',
    token = os.getenv('SOURCERY_TOKEN'),
  }
})

-- lsp.configure('tsserver', {
--   settings = {
--   -- Needed for inlayHints. Merge this table with your settings or copy
--   -- it from the source if you want to add your own init_options.
--   init_options = require('nvim-lsp-ts-utils').init_options,
--   on_attach = function(client)
--     local ts_utils = require('nvim-lsp-ts-utils')

--     ts_utils.setup({
--     enable_import_on_completion = true,
--     update_imports_on_move = true,
--     require_confirmation_on_move = true,
--     })

--     -- Required to fix code action ranges and filter diagnostics.
--     ts_utils.setup_client(client)
--   end
--   }
-- })

lsp.setup()
