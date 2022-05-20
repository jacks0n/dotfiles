local lsp_installer = require('nvim-lsp-installer')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local lspconfig = require('lspconfig')

lsp_installer.setup({})

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lspServer in pairs(lsp_installer.get_installed_servers()) do
  local config = {
    capabilities = capabilities
  }
  local lspServerName = lspServer['name']
  if lspServerName == 'sourcery' then
    config.init_options = {
      editor_version = 'vim',
      extension_version = 'vim.lsp',
      token = os.getenv('SOURCERY_TOKEN'),
    }
  elseif lspServerName == 'tsserver' then
    -- Needed for inlayHints. Merge this table with your settings or copy
    -- it from the source if you want to add your own init_options.
    config.init_options = require('nvim-lsp-ts-utils').init_options
    config.on_attach = function(client, bufnr)
      local ts_utils = require('nvim-lsp-ts-utils')

      ts_utils.setup({
        enable_import_on_completion = true,
        update_imports_on_move = true,
        require_confirmation_on_move = true,
      })

      -- Required to fix code action ranges and filter diagnostics.
      ts_utils.setup_client(client)
    end
  end
  lspconfig[lspServerName].setup(config)
end
