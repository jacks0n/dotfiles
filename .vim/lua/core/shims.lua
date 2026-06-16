-- Forward-compat polyfills.
--
-- This config calls modern Neovim APIs everywhere; this module backfills them on
-- older Neovim (e.g. the nvim builds shipped by Debian/Ubuntu). On Neovim 0.11+
-- every guard below is false, so the module is a no-op. It MUST be required
-- before any other core/plugin module so the new APIs always exist.

-- vim.highlight was renamed to vim.hl in 0.11 (old name deprecated, slated for
-- removal). Alias forward so vim.hl.* works on older Neovim too.
if vim.hl == nil and vim.highlight ~= nil then
  vim.hl = vim.highlight
end

-- vim.lsp.config / vim.lsp.enable are the native server-config API (0.11+). On
-- older Neovim, reproduce the surface this config uses and delegate to the
-- nvim-lspconfig framework, which does the same job there.
--
-- Limitation: vim.lsp.config[name] returns only the config we assigned, not one
-- merged with nvim-lspconfig's shipped defaults. Code that reads a *resolved*
-- field (e.g. a default `cmd`) off it won't see that default on the polyfill.
-- Server enablement itself is unaffected.
if vim.lsp.config == nil then
  -- name -> config table; '*' holds defaults merged into every server.
  local store = { ['*'] = {} }

  -- Real vim.lsp.config supports BOTH vim.lsp.config(name, cfg) and
  -- vim.lsp.config[name] = cfg / reads via vim.lsp.config[name]. The proxy table
  -- is always empty, so every access routes through store.
  vim.lsp.config = setmetatable({}, {
    __call = function(_, name, cfg)
      store[name] = vim.tbl_deep_extend('force', store[name] or {}, cfg or {})
      return store[name]
    end,
    __index = function(_, name)
      return store[name]
    end,
    __newindex = function(_, name, cfg)
      store[name] = cfg
    end,
  })

  -- New-API config uses root_markers and an async root_dir(bufnr, on_dir);
  -- nvim-lspconfig wants a sync root_dir(fname). Translate both.
  local function to_lspconfig(cfg)
    local out = vim.deepcopy(cfg)
    if type(out.root_dir) == 'function' then
      local async_root_dir = out.root_dir
      out.root_dir = function(fname)
        local result
        async_root_dir(vim.fn.bufnr(fname), function(dir)
          result = dir
        end)
        return result
      end
    elseif out.root_markers then
      out.root_dir = require('lspconfig.util').root_pattern(unpack(out.root_markers))
    end
    out.root_markers = nil
    return out
  end

  function vim.lsp.enable(names)
    for _, name in ipairs(type(names) == 'table' and names or { names }) do
      local merged = vim.tbl_deep_extend('force', store['*'] or {}, store[name] or {})
      require('lspconfig')[name].setup(to_lspconfig(merged))
    end
  end
end
