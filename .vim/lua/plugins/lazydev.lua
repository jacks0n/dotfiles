local M = {}

-- Setup lazydev for faster Lua development
local status_ok, lazydev = pcall(require, 'lazydev')
if not status_ok then
  return M
end

lazydev.setup({
  -- Only load library types and docs for modules that are actually required
  -- This makes startup and completion much faster
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = "luvit-meta/library", words = { "vim%.uv" } },
  },
})

return M