-- Tool installation handled by :MasonInstallAll / :MasonInstallNullLs in mason.lua
require('mason-null-ls').setup({
  ensure_installed = {},
  automatic_installation = false,
  -- No-op handler: none-ls.lua handles registration with conditional patterns
  handlers = { function() end },
})
