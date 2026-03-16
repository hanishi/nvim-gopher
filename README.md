# nvim-gopher

Minimal, single-file Neovim configuration for Go development. No plugin manager — plugins are git-cloned directly.

![demo](demo.gif)

## Quick Start

```sh
git clone https://github.com/hanishi/nvim-gopher ~/.config/nvim
~/.config/nvim/install.sh
```

## What's Included

**Tools** (installed via Homebrew): neovim, go, gopls, ripgrep, delve, gomodifytags, gotests

**Features**:
- Tab-centric workflow — files open in new tabs from the file tree
- gopls with gofumpt, staticcheck, and all analyses enabled
- Auto format + organize imports on save
- Go snippets: `iferr`, `tt` (table-driven test), `errw` (error wrap)
- Debugging with delve via DAP (buffers auto-lock during debug)
- Test runner (neotest-go) and test generation (gotests)
- Go tooling via go.nvim (`:GoAddTag`, `:GoImpl`, `:GoFillStruct`, `:GoIfErr`, `:GoCoverage`, etc.)
- Go Playground sharing (`:GoPlay`)
- Treesitter textobjects — select/move/swap by function, class, parameter
- Diagnostics panel (trouble.nvim)
- Surround editing (nvim-surround)
- TODO/FIXME/HACK highlighting and search
- Indent guides (indent-blankline)
- LSP progress indicator (fidget.nvim)
- Go stdlib and module cache files are read-only
- System clipboard sync
- Dashboard with live project stats

Press `Space ?` inside Neovim to open the full cheatsheet.

## Plugins (29)

alpha-nvim, nvim-tree, telescope, nvim-cmp, LuaSnip, nvim-autopairs, nvim-treesitter, nvim-treesitter-textobjects, neotest-go, nvim-dap-go, dap-ui, gitsigns, vim-fugitive, lualine, which-key, go.nvim, trouble.nvim, conform.nvim, nvim-surround, todo-comments.nvim, indent-blankline.nvim, fidget.nvim

## Updating Plugins

Run `:PluginUpdate` inside Neovim to git-pull all plugins.

## Recording the Demo

```sh
cd ~/.config/nvim
vhs demo.tape
```
