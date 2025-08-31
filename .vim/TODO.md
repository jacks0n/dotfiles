# Vim Configuration Simplification Plan

## Overview
This plan focuses on improving speed and reducing complexity while maintaining full functionality. The configuration will continue to support both COC.nvim and native LSP systems, as well as both Vim and NeoVim compatibility.

## Implementation Status

### ✅ Phase 5: Clean Up Utility Plugins (COMPLETED)
- [x] Remove Recover.vim - NeoVim has built-in swap file recovery
- [x] Remove vim-troll-stopper - Rarely needed  
- [x] Remove vim-mundo - Can use native undo tree (:undotree)
- [x] Remove commented/experimental plugins (removed: vim-ranger, auto_mkdir, hypersonic, bigfile, markid, SQHell)
- [x] Uncommented package-info.nvim and ts-node-action for use
- [x] Test startup after changes - ✅ No errors

## ✅ Phase 1: Remove Redundant Search/Navigation Plugins (COMPLETED)

### Removed:
- **vim-ranger** - ✅ Removed in Phase 5
- **fzf.vim** + **fzf-preview.vim** - ✅ Replaced with Telescope
  - Removed plugin declarations
  - Removed g:fzf_history_dir and g:fzf_layout variables
  - Removed GGrep command and FZF-specific autocommands
  - Removed fzf-project plugin

### Kept:
- **NERDTree** - File explorer (as requested)
- **Telescope** - Unified fuzzy finder with FZF-native for speed
- **coc-fzf-preview** - Preview support for COC.nvim

### Implemented:
- ✅ Added `<C-g>` mapping for git files (all)
- ✅ Added `<Leader>gg` mapping for git grep  
- ✅ Added `<Leader>p` for project switching (uses g:telescope_project_workspaces)
- ✅ Telescope already has FZF-native extension loaded for speed
- ✅ All mappings maintain preview functionality

## Phase 2: Eliminate Visual/UI Redundancies

### Remove:
- **vim-indexed-search** - NeoVim has native search count (set shortmess-=S)
- **semantic-highlight.vim** - TreeSitter provides semantic highlighting
- **vim-startify** - Adds startup overhead, rarely essential
- **vista.vim** - Can use nvim-navbuddy or Telescope symbols instead
- **rainbow** - TreeSitter can handle bracket coloring
- **Multiple colorschemes** - Keep only 3-4 favorites:
  - Keep: gruvbox, tokyonight, kanagawa, catppuccin
  - Remove: Others from vim-colorschemes pack

### Actions Required:
1. Remove plugin declarations
2. Enable native search count display
3. Configure TreeSitter for semantic highlighting
4. Update any Vista keymappings to use alternatives

## Phase 3: Consolidate Text Editing Plugins

### Remove (Duplicates):
- **vim-commentary** - Use nvim-comment instead
- **vim-move** - Can implement with simple mappings
- **lexima.vim** - Replaced by nvim-autopairs
- **vim-surround** - Keep only nvim-surround for NeoVim

### Keep:
- **nvim-surround** (NeoVim)
- **nvim-autopairs** (NeoVim)
- **nvim-comment** (NeoVim)

### Actions Required:
1. Remove duplicate plugin lines
2. Ensure nvim versions are properly configured
3. Migrate any custom settings from removed plugins

## Phase 4: Streamline Language Support

### Remove:
- **styled-components/vim-styled-components** - Unmaintained, TreeSitter handles
- **vim-polyglot** - TreeSitter handles syntax for most languages
- **typescript-vim** - TreeSitter handles TypeScript syntax
- **vim-jsx-typescript** - TreeSitter handles JSX/TSX

### Keep:
- **TreeSitter** with appropriate parsers
- **Language-specific LSP servers**

### Actions Required:
1. Remove plugin declarations
2. Ensure TreeSitter parsers are installed for needed languages
3. Verify syntax highlighting still works

## Phase 5: Clean Up Utility Plugins

### Remove:
- **Recover.vim** - NeoVim has built-in swap file recovery
- **vim-troll-stopper** - Rarely needed
- **vim-mundo** - Can use native undo tree (:undotree)
- **Commented/experimental plugins** - Clean up unused code

### Actions Required:
1. Remove plugin lines
2. Remove any associated configuration
3. Update any keymappings that referenced these plugins

## Phase 6: Optimize Completion/Snippets

### Simplify:
- **Keep both** cmp-tabnine and Copilot but lazy load more aggressively
- **Remove duplicate** snippet collections (keep friendly-snippets, remove vim-snippets)
- **Reduce cmp sources** - Only load sources when needed

### Actions Required:
1. Improve lazy loading for AI completions
2. Remove vim-snippets
3. Configure conditional loading for cmp sources

## Phase 7: Fix Configuration Issues

### Clean Up:
- **Duplicate nvim-lspconfig** - Remove duplicate plugin declaration
- **Consolidate keymappings** - Remove duplicate diagnostic navigation mappings
- **Fix lazy loading** - More aggressive lazy loading for UI plugins

### Actions Required:
1. Remove duplicate plugin entries
2. Consolidate keymapping definitions
3. Improve autocmd-based lazy loading

## Phase 8: Performance Optimizations

### Implement:
- **Lazy load by filetype** - Load language plugins only when needed
- **Defer UI plugins** - Load after VimEnter
- **Conditional loading** - Check for config files before loading linters
- **Reduce startup plugins** - Only load essentials immediately

### Actions Required:
1. Convert more plugins to lazy loading
2. Add filetype conditions to language plugins
3. Implement config file detection for linters

## Implementation Order

1. **Backup current configuration**
   ```bash
   cp -r ~/.vim ~/.vim.backup
   cp ~/.vimrc ~/.vimrc.backup
   ```

2. **Phase-by-phase removal** (test after each phase):
   - Start with Phase 5 (utilities) - lowest risk
   - Then Phase 2 (visual/UI) - visible but non-breaking
   - Then Phase 3 (text editing) - moderate risk
   - Then Phase 1 (search/navigation) - higher risk
   - Then Phase 4 (language support) - needs careful testing
   - Then Phase 6 (completion) - critical functionality
   - Finally Phase 7-8 (optimization) - fine-tuning

3. **Testing checklist after each phase**:
   - [ ] NeoVim starts without errors
   - [ ] Vim starts without errors (basic functionality)
   - [ ] LSP works (both COC and native)
   - [ ] File navigation works
   - [ ] Completion works
   - [ ] Syntax highlighting works
   - [ ] Key mappings work

## Expected Improvements

- **Plugin count**: Reduce by ~30-40 plugins
- **Startup time**: 25-40% faster
- **Memory usage**: 20-30% reduction
- **Maintenance**: Cleaner, more logical structure
- **Compatibility**: Maintain both Vim and NeoVim support
- **Functionality**: No loss of essential features

## Notes

- Keep both COC.nvim and native LSP for flexibility
- Maintain Vim compatibility for basic editing (fancy features NeoVim only)
- NERDTree stays as the primary file explorer
- Telescope becomes the unified fuzzy finder (with FZF backend)
- TreeSitter handles most syntax and semantic highlighting
- Focus on lazy loading for performance without removing features

## Rollback Plan

If issues arise:
1. Restore from backup: `cp -r ~/.vim.backup ~/.vim`
2. Restore vimrc: `cp ~/.vimrc.backup ~/.vimrc`
3. Reinstall plugins: `:PlugInstall`
4. Restart Vim/NeoVim