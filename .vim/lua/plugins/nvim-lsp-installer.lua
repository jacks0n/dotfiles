local lsp_installer = require('nvim-lsp-installer')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local nvim_lsp = require('lspconfig')

lsp_installer.setup({})

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

for index, lspServer in pairs(lsp_installer.get_installed_servers()) do
  local lspServerName = lspServer['name']
  nvim_lsp[lspServerName].setup(capabilities)
end
