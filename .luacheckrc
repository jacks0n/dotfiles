-- vim: filetype=lua
--- @see https://github.com/mpeterv/luacheck/blob/7360cfb4cf2c7dd8c73adf45e31a04811a745250/docsrc/cli.rst
--- Show ranges of columns related to warnings.
ranges = true

-- Show the warning/error codes as well.
codes = true

-- Don't show files with no issues.
quiet = 1

-- Global objects defined by the C code.
read_globals = { "vim" }

-- Set standard globals.
std = "luajit+luacheckrc"

-- Rerun tests only if their modification time changed.
cache = true

include_files = { "lua/*.lua", "lua/**/*.lua", "test/lua/*.lua", ".luacheckrc" }
