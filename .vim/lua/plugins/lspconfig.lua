local mason_lspconfig = require('mason-lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

---@param opts table|nil
local function create_capabilities(opts)
  local default_opts = {
    with_snippet_support = true,
  }
  opts = opts or default_opts
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = opts.with_snippet_support
  if opts.with_snippet_support then
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      },
    }
  end
  return cmp_nvim_lsp.update_capabilities(capabilities)
end

util.on_setup = util.add_hook_after(util.on_setup, function(config)
  config.capabilities = create_capabilities()
end)

require('mason-lspconfig').setup({
  ensure_installed = {
    'bashls',
    'cssls',
    'cucumber_language_server',
    'dockerls',
    'eslint',
    'html',
    'intelephense',
    'jsonls',
    'lemminx',
    'phpactor',
    'psalm',
    'pyright',
    'sourcery',
    -- 'sqlls',
    'sqls',
    'sumneko_lua',
    'terraformls',
    'tflint',
    'tsserver',
    'vimls',
    'yamlls',
  },
  automatic_installation = true,
  ui = {
    icons = {
      package_installed = "",
      package_pending = "",
      package_uninstalled = "",
    },
  },
})

require('mason-lspconfig').setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {}
  end,
  ['jsonls'] = function()
    lspconfig.jsonls.setup {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
        },
      },
    }
  end,
  ['yamlls'] = function()
    lspconfig.yamlls.setup {
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
    }
  end,
  ['sourcery'] = function()
    lspconfig.sourcery.setup {
      init_options = {
        editor_version = 'vim',
        extension_version = 'vim.lsp',
        token = os.getenv('SOURCERY_TOKEN'),
      }
    }
  end,
  ['tsserver'] = function()
    lspconfig.tsserver.setup {
      -- Needed for inlayHints. Merge this table with your settings or copy
      -- it from the source if you want to add your own init_options.
      init_options = require('nvim-lsp-ts-utils').init_options,
      on_attach = function(client)
        local ts_utils = require('nvim-lsp-ts-utils')

        ts_utils.setup({
          enable_import_on_completion = true,
          update_imports_on_move = true,
          require_confirmation_on_move = true,
        })

        -- Required to fix code action ranges and filter diagnostics.
        ts_utils.setup_client(client)
      end
    }
  end,
}
