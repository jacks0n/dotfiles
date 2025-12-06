local lsp = require('core.lsp')

-- Configure roslyn LSP settings via vim.lsp.config
vim.lsp.config("roslyn", {
  on_attach = lsp.on_attach_default,
})

-- Configure roslyn.nvim plugin settings
require('roslyn').setup({
  broad_search = true,
  silent = false,
  filewatching = 'off',

  -- Automatically choose the solution closest to root (shortest path)
  -- This is typically the most comprehensive solution containing the most projects
  choose_target = function(targets)
    vim.notify(string.format("choose_target called with %d targets: %s", #targets, vim.inspect(targets)), vim.log.levels.INFO)
    table.sort(targets, function(a, b)
      return #a < #b
    end)
    local chosen = targets[1]
    vim.notify(string.format("choose_target returning: %s", chosen), vim.log.levels.INFO)
    return chosen
  end,
})
