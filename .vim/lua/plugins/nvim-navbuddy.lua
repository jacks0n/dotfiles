local navbuddy = require("nvim-navbuddy")

navbuddy.setup({
  window = {
    size = "80%",
  },
})

vim.keymap.set("n", "<Leader>lb", navbuddy.open, { desc = "Navbuddy LSP breadcrumbs" })
