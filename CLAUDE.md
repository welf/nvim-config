# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Neovim Configuration Testing

- Test the configuration by launching Neovim: `nvim`
- Check plugin status: Open Neovim and run `:Lazy` to view plugin manager
- Update plugins: `:Lazy update`
- Check LSP status: `:LspInfo`
- View keymapping help: `<Leader>` then wait for which-key popup

### Code Formatting

- Format current buffer: `<Leader>cf` (uses conform.nvim)
- Format on save is enabled for most languages (disabled for C/C++/Rust to use LSP formatting)
- Formatters configured: biome (JS/TS), stylua (Lua), prettier (Markdown)

### Debugging (Rust-focused)

- Run Rust testables: `<Leader>dt`
- Toggle breakpoint: `<Leader>db`
- Start/continue debugging: `<Leader>d>`
- Step into: `<Leader>dl`
- Step over: `<Leader>dj`
- Step out: `<Leader>dk`

### Rust Testing (Cargo Nextest)

- Run all workspace tests: `<Leader>rta`
- Run current file tests: `<Leader>rtt` or `<Leader>rtf`
- Run last test: `<Leader>rtl`
- Run doc tests: `<Leader>rtD`
- Run specific test (filter): `<Leader>rts`
- Run package tests: `<Leader>rtp`
- Run tests (verbose): `<Leader>rtv`
- Run tests (release): `<Leader>rtr`
- List all tests: `<Leader>rtL`
- Run ignored tests: `<Leader>rti`
- Run with coverage: `<Leader>rtC`

## Architecture Overview

This is a modular Neovim configuration built around lazy.nvim plugin manager with 50+ plugins. The architecture follows clear separation of concerns:

### Core Structure

- `init.lua` - Entry point, basic settings, leader key (space)
- `lua/aw/lazy.lua` - Plugin manager bootstrap
- `lua/aw/core/` - Core functionality (autocommands, keymappings)
- `lua/aw/plugins/` - Individual plugin configurations (54 files)

### Key Design Patterns

- **Modular organization**: Each plugin gets its own config file
- **Lazy loading**: Extensive use of event-based and filetype-based loading
- **Language-specific optimization**: Particularly strong Rust development support
- **AI integration**: Multiple assistants (Copilot, CodeCompanion) with custom keymappings

### Core Modules (`lua/aw/core/`)

- `autocmd.lua` - Autocommands including highlight on yank, LSP startup, Rust auto-save
- `mappings/` - 14 specialized keymapping files organized by function:
  - `basic.lua` - Core Vim operations
  - `debug.lua` - Debugging with nvim-dap and Rust testables
  - `git.lua` - Git operations
  - `telescope.lua` - Fuzzy finding
  - `claude-ai.lua` - AI assistant integration
  - And 9 other specialized categories

### Major Plugin Categories

- **LSP & Language Support**: lspconfig, mason, rustaceanvim, typescript-tools
- **Code Intelligence**: nvim-cmp, conform, treesitter, copilot
- **UI & Navigation**: telescope, neo-tree, lualine, dashboard
- **Development Tools**: nvim-dap, gitsigns, trouble, todo-comments

### Language-Specific Features

- **Rust**: Advanced support via rustaceanvim with clippy, cargo, debugging, testables
- **TypeScript/JavaScript**: Dedicated tooling with biome formatting
- **Markdown**: Prettier formatting, visual wrapping, enhanced rendering
- **Lua**: LSP setup for Neovim development with lazydev

### Default Settings

- Leader key: `<space>`
- Indentation: 2 spaces
- Line numbers enabled
- System clipboard integration
- Netrw disabled (uses neo-tree)
- Default colorscheme: nightfox

### Performance Optimizations

- Lazy loading for most plugins
- Event-based loading patterns
- Optimized startup through deferred loading
- Plugin version locking via lazy-lock.json

## File Editing Guidelines

When modifying this configuration:

- Follow the modular structure - add new plugins to `lua/aw/plugins/`
- Keep keymappings organized in their respective `mappings/` files
- Use lazy loading configurations for new plugins
- Maintain the existing indentation (2 spaces) and Lua style
- Test changes by reloading Neovim configuration

