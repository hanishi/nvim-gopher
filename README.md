# Neovim Go Setup

Minimal, single-file Neovim configuration for Go development. No plugin manager — plugins are git-cloned directly.

## Quick Start

```sh
git clone https://github.com/hanishi/nvim-gopher ~/.config/nvim
~/.config/nvim/install.sh
```

## What's Included

**Tools** (installed via Homebrew): neovim, go, gopls, ripgrep, delve

**Plugins**: alpha-nvim, nvim-tree, telescope, nvim-cmp, LuaSnip, nvim-autopairs, nvim-treesitter, neotest-go, nvim-dap-go, dap-ui, gitsigns, vim-fugitive, lualine, which-key

**Features**:
- Tab-centric workflow — files open in new tabs from the file tree
- gopls with gofumpt, staticcheck, and all analyses enabled
- Auto format + organize imports on save
- Go snippets: `iferr`, `tt` (table-driven test), `errw` (error wrap)
- Debugging with delve via DAP
- System clipboard sync

Press `Space ?` inside Neovim to open the full cheatsheet.

## Updating Plugins

Run `:PluginUpdate` inside Neovim to git-pull all plugins.
