# Neovim Go Cheatsheet

Leader key: `Space`

## File Tree (nvim-tree)

| Key | Action |
|-----|--------|
| `Space n` | Toggle file tree |
| `Space N` | Reveal current file in tree |
| `Enter` | Open file in new tab (or jump to existing tab) |
| `C-t` | Open file in new tab |
| `a` | Create file/directory |
| `d` | Delete |
| `r` | Rename |
| `x` | Cut |
| `c` | Copy |
| `p` | Paste |

## Tabs

| Key | Action |
|-----|--------|
| `Space 1-5` | Jump to tab 1-5 |
| `Space ]` | Next tab |
| `Space [` | Previous tab |
| `Space w` | Close tab |
| `gt` / `gT` | Next / previous tab |

## Window Navigation

| Key | Action |
|-----|--------|
| `C-w h` | Move to left window |
| `C-w l` | Move to right window |
| `C-w j` | Move to window below |
| `C-w k` | Move to window above |
| `C-w w` | Cycle windows |

## LSP (requires gopls)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find references (Telescope) |
| `K` | Hover docs |
| `C-k` | Signature help |
| `Space ca` | Code action |
| `Space rn` | Rename symbol |
| `Space ds` | Document symbols |
| `Space ws` | Workspace symbols |
| `C-o` | Jump back |
| `C-i` | Jump forward |

## Diagnostics

| Key | Action |
|-----|--------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `Space e` | Show diagnostic float |
| `Space q` | Send diagnostics to loclist |

## Completion (nvim-cmp)

| Key | Action |
|-----|--------|
| `C-Space` | Trigger completion |
| `Tab` | Next item |
| `S-Tab` | Previous item |
| `Enter` | Confirm selection |
| `C-d` | Scroll docs down |
| `C-u` | Scroll docs up |

## Telescope

| Key | Action |
|-----|--------|
| `Space ff` | Find files |
| `Space fg` | Live grep |
| `Space fb` | Buffers |
| `Space fh` | Help tags |

## Tests (neotest)

| Key | Action |
|-----|--------|
| `Space tr` | Run nearest test |
| `Space tf` | Run file tests |
| `Space ts` | Toggle test summary |
| `Space to` | Show test output |

## Debugger (DAP)

| Key | Action |
|-----|--------|
| `Space db` | Toggle breakpoint |
| `Space dB` | Conditional breakpoint |
| `Space dc` | Start / continue |
| `Space dt` | Debug nearest test |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |

## Git

### Gitsigns (in-buffer)

| Key | Action |
|-----|--------|
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `Space hs` | Stage hunk |
| `Space hr` | Reset hunk |
| `Space hp` | Preview hunk |
| `Space hb` | Blame line |

### Fugitive (commands)

| Command | Action |
|---------|--------|
| `:Git blame` | Full file blame |
| `:Git diff` | Git diff |
| `:Git log` | Git log |
| `:Git push` | Push |
| `:Git pull` | Pull |

## Editing

| Key | Action |
|-----|--------|
| `V` | Select line (extend with `j`/`k`) |
| `v` | Select characters |
| `Vip` | Select paragraph |
| `J` (visual) | Move selection down |
| `K` (visual) | Move selection up |
| `gcc` | Toggle comment on line |
| `gc` (visual) | Toggle comment on selection |

## Clipboard

System clipboard is synced — `y`/`d`/`p` work with Cmd+C/Cmd+V.

| Key | Action |
|-----|--------|
| `yy` | Copy line |
| `yiw` | Copy word |
| `v` then `y` | Select then copy |
| `p` | Paste after |
| `P` | Paste before |
| `dd` | Cut line |

## Snippets (LuaSnip)

Type the trigger and press `Tab` to expand, then `Tab`/`S-Tab` to jump between placeholders.

| Trigger | Expands to |
|---------|------------|
| `iferr` | `if err != nil { return err }` |
| `tt` | Table-driven test scaffold |
| `errw` | `fmt.Errorf("...: %w", err)` |

## On Save (automatic)

- Organizes imports (goimports)
- Formats code (gofumpt)

## Other

| Key | Action |
|-----|--------|
| `Space cc` | Open Claude Code |
| `Space` | Which-key popup (shows all keybindings) |
| `C-\ C-n` | Exit terminal mode |
