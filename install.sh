#!/usr/bin/env bash
set -euo pipefail

echo "=== Neovim Go Development Setup ==="
echo ""

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi

# --- Core tools ---
echo "Installing core tools via Homebrew..."
brew install neovim go gopls ripgrep delve 2>/dev/null || brew upgrade neovim go gopls ripgrep delve 2>/dev/null || true

# --- Go tools ---
echo "Installing Go tools..."
go install github.com/fatih/gomodifytags@latest
go install github.com/cweill/gotests/gotests@latest

# --- Config files ---
CONFIG_DIR="${HOME}/.config/nvim"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$SCRIPT_DIR" != "$CONFIG_DIR" ]; then
  mkdir -p "$CONFIG_DIR"
  for file in init.lua cheatsheet.md install.sh; do
    src="$SCRIPT_DIR/$file"
    dest="$CONFIG_DIR/$file"
    if [ -f "$src" ] && [ "$src" != "$dest" ]; then
      if [ -f "$dest" ]; then
        echo "Backing up existing $file to ${file}.bak"
        cp "$dest" "${dest}.bak"
      fi
      cp "$src" "$dest"
      echo "Copied $file to $CONFIG_DIR"
    fi
  done
fi

# --- Plugins ---
PACK_DIR="${HOME}/.local/share/nvim/site/pack/plugins/start"
mkdir -p "$PACK_DIR"

plugins=(
  "https://github.com/goolord/alpha-nvim.git"
  "https://github.com/hrsh7th/cmp-nvim-lsp"
  "https://github.com/hrsh7th/nvim-cmp"
  "https://github.com/saadparwaiz1/cmp_luasnip"
  "https://github.com/L3MON4D3/LuaSnip"
  "https://github.com/windwp/nvim-autopairs.git"
  "https://github.com/nvim-lua/plenary.nvim"
  "https://github.com/nvim-telescope/telescope.nvim"
  "https://github.com/nvim-tree/nvim-tree.lua.git"
  "https://github.com/nvim-tree/nvim-web-devicons.git"
  "https://github.com/nvim-treesitter/nvim-treesitter.git"
  "https://github.com/nvim-neotest/neotest"
  "https://github.com/nvim-neotest/neotest-go"
  "https://github.com/nvim-neotest/nvim-nio"
  "https://github.com/mfussenegger/nvim-dap"
  "https://github.com/leoluz/nvim-dap-go"
  "https://github.com/rcarriga/nvim-dap-ui"
  "https://github.com/lewis6991/gitsigns.nvim.git"
  "https://github.com/tpope/vim-fugitive.git"
  "https://github.com/nvim-lualine/lualine.nvim.git"
  "https://github.com/folke/which-key.nvim.git"
)

for url in "${plugins[@]}"; do
  name=$(basename "$url" .git)
  dest="$PACK_DIR/$name"
  if [ -d "$dest" ]; then
    echo "Already installed: $name"
  else
    echo "Installing: $name"
    git clone --depth 1 "$url" "$dest"
  fi
done

# --- Treesitter parsers ---
echo ""
echo "Installing treesitter parsers..."
nvim --headless \
  -c "TSInstallSync go gomod lua json yaml toml bash python javascript typescript html css dockerfile markdown" \
  -c "qall" 2>/dev/null || echo "Note: Run :TSInstall manually if parser installation failed."

echo ""
echo "=== Setup complete ==="
echo "Tools: neovim, go, gopls, ripgrep, delve, gomodifytags, gotests"
echo "Plugins: $(ls "$PACK_DIR" | wc -l | tr -d ' ') installed"
echo ""
echo "Run 'nvim' to get started. Use :PluginUpdate to update plugins later."
