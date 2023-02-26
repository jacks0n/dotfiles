require('typescript').setup({
  -- Enable commands.
  disable_commands = false,
  -- Disable debug logging for commands.
  debug = false,
  go_to_source_definition = {
    -- Fall back to standard LSP definition on failure.
    fallback = true,
  },
})
