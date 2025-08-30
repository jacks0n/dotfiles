local M = {}

local status_ok, lazydev = pcall(require, "lazydev")
if not status_ok then
  return M
end

lazydev.setup({
  library = {
    { path = "luvit-meta/library", words = { "vim%.uv" } },
  },
})

return M
