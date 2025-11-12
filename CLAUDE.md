# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive dotfiles repository for macOS development environments, primarily focused on shell configuration (zsh), Git workflows, and an advanced NeoVim setup. The configuration supports full-stack development with particular strength in JavaScript/TypeScript, Python, and PHP.

## Common Commands

### Setup and Installation
```bash
# Initial setup (links dotfiles to home directory)
./setup.sh

# Full system installation (installs all dependencies)
./install.sh

# Update everything (system, packages, plugins)
update

# Update just system packages
update-global

# Update just user packages and plugins
update-user
```

### Development Workflow
```bash
# Project switching (fzf-based)
<C-p>              # In vim: quick project switch
fzf-project        # In shell: interactive project selector

# Git maintenance
git_maintain       # Clean up repository (gc, prune, etc.)
cleanup-local-branches  # Remove merged local branches

# System cleanup
bin/cleanup        # Clear caches, logs, browser history
```

### Vim/NeoVim Commands
```bash
# Plugin management
:PlugInstall       # Install plugins
:PlugUpdate        # Update plugins
:PlugClean         # Remove unused plugins

# LSP management (if using native LSP)
:Mason             # Open LSP server installer
:LspInfo           # Show LSP server status
:LspRestart        # Restart LSP servers

# Formatting and linting
<leader>fm         # Format current buffer
<leader>fl         # Lint current buffer
:FormatToggle      # Toggle format-on-save
```

## Architecture

### Configuration Structure
```
.dotfiles/
├── Core Shell Config
│   ├── .zshrc              # Main shell configuration
│   ├── .functions          # Custom shell functions
│   ├── .aliases           # Command aliases
│   └── .exports           # Environment variables
├── Git Configuration
│   ├── .gitconfig         # Git settings with delta diff
│   └── .gitalias          # Extended git aliases
├── NeoVim Configuration
│   ├── .vimrc             # Legacy vim config
│   ├── .vim/init.vim      # NeoVim entry point
│   └── .vim/lua/          # Modern Lua configuration
└── Development Tools
    ├── .tmux.conf         # Terminal multiplexer
    ├── .editorconfig      # Editor consistency
    └── bin/               # Custom scripts
```

### NeoVim Architecture

The NeoVim configuration supports dual completion systems:
- **COC.nvim** (traditional, set via `g:use_coc`)
- **Native LSP** (modern, default)

#### Lua Module Organization
```
.vim/lua/
├── core/
│   ├── settings.lua    # Core Neovim settings
│   ├── lsp.lua        # LSP server configurations (Mason-based)
│   ├── diagnostic.lua # Diagnostic display and navigation
│   ├── keymaps.lua    # Key mappings
│   ├── autocmds.lua   # Auto commands
│   └── linters.lua    # Unified tool configuration for none-ls
└── plugins/
    ├── cmp.lua        # Completion configuration
    ├── telescope.lua  # Fuzzy finder
    ├── lualine.lua    # Status line
    └── [30+ other plugin configs]
```

#### Key Features
- **Lazy Loading**: Plugins load on demand for fast startup
- **Mason Integration**: Automatic LSP server and tool management via mason-null-ls
- **Unified Linting & Formatting**: Uses none-ls with pattern-based conditional tool loading
- **Smart Tool Activation**: Tools only run when their config files exist in the repository
- **AI Integration**: Copilot + TabNine for code completion

### Language Support

Fully configured with LSP, formatting, and linting for:
- **JavaScript/TypeScript**: ts_ls, eslint_d, prettierd
- **Python**: pyright, ruff, flake8, mypy
- **PHP**: intelephense, phpcs, phpstan, php-cs-fixer
- **Lua**: lua_ls, stylua, luacheck
- **Go**: gopls, gofmt
- **Rust**: rust-analyzer, rustfmt
- **SQL**: sqlfluff
- **Terraform**: terraform-ls, tflint, terraform fmt
- **Shell**: shellcheck
- **CSS/SCSS**: stylelint
- **Markdown**: markdownlint
- **And more...**

## Key Mappings (NeoVim)

### LSP Navigation
- `gd` - Go to definition
- `gi` - Go to implementation
- `gr` - Go to references
- `gt` - Go to type definition
- `K` - Show hover information

### Diagnostics
- `[d` / `]d` - Previous/next diagnostic
- `[e` / `]e` - Previous/next error
- `[w` / `]w` - Previous/next warning
- `<leader>e` - Open diagnostic float

### File Navigation
- `<leader>f` - Find files (Telescope)
- `<leader>b` - Find buffers
- `<C-g>` - Find git files
- `<leader>t` - Search in files (grep)
- `<C-p>` - Switch projects

### Code Actions
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>fm` - Format buffer
- `<leader>fl` - Lint buffer

## Environment Variables

Key environment variables defined in `.exports`:
- `DOTFILES_PATH` - Path to dotfiles repository
- `EDITOR` - Set to `nvim`
- `BROWSER` - Set to `brave-browser`
- Language-specific paths (Node, Python, Go, etc.)

## Maintenance

### Regular Tasks
- Run `update` weekly to keep system current
- Use `git_maintain` in repositories to keep them clean
- Run `bin/cleanup` monthly for system cleanup

### Plugin Management
- NeoVim plugins managed via vim-plug
- LSP servers managed via Mason (mason-lspconfig)
- Linters/formatters managed via Mason (mason-null-ls)
- System packages managed via Homebrew

### Configuration Updates
- Core settings: Edit `lua/core/settings.lua`
- Key mappings: Edit `lua/core/keymaps.lua`
- LSP setup: Edit `lua/core/lsp.lua`
- Add new languages: Update `lua/core/lsp.lua` and `lua/core/linters.lua`

## Special Considerations

### Performance
- Lazy loading implemented for startup optimization
- Large file handling with size limits on formatting
- Conditional linter loading based on config file presence

### COC vs Native LSP
The configuration can switch between completion systems:
- Set `let g:use_coc = 1` in `~/.vimrc.local` for COC.nvim
- Default (unset) uses native LSP with Mason

### Private Configuration
- `~/.vimrc.local` - Local vim overrides
- `private/` directory - Personal configurations not committed
- `~/intelephense/license.txt` - Intelephense Pro license

This configuration represents a production-ready development environment optimized for modern full-stack development workflows.