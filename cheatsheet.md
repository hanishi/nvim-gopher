# Neovim Go Cheatsheet

Leader key: `Space`

## File Tree (nvim-tree)

| Key | Action |
|-----|--------|
| `Space n` | Toggle file tree |
| `Space N` | Reveal current file in tree |
| `Enter` | Open file in new tab (or jump to existing tab) |
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
| `C-w h/j/k/l` | Move to left/down/up/right window |
| `C-w w` | Cycle windows |

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

## LSP (gopls)

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
| `C-o` / `C-i` | Jump back / forward |

## Diagnostics

| Key | Action |
|-----|--------|
| `[d` / `]d` | Previous / next diagnostic |
| `Space e` | Show diagnostic float |
| `Space q` | Send diagnostics to loclist |

## Completion (nvim-cmp)

| Key | Action |
|-----|--------|
| `C-Space` | Trigger completion |
| `Tab` | Next item / expand snippet / jump forward |
| `S-Tab` | Previous item / jump backward |
| `Enter` | Confirm selection |
| `C-d` / `C-u` | Scroll docs down / up |

## Snippets (LuaSnip)

Type trigger then `Tab` to expand, `Tab`/`S-Tab` to jump between placeholders.

| Trigger | Expands to |
|---------|------------|
| `iferr` | `if err != nil { return err }` |
| `tt` | Table-driven test scaffold |
| `errw` | `fmt.Errorf("...: %w", err)` |

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

All Go buffers are locked read-only during debug sessions.

| Key | Action |
|-----|--------|
| `Space db` | Toggle breakpoint |
| `Space dB` | Conditional breakpoint |
| `Space dc` | Start / continue |
| `Space dt` | Debug nearest test |
| `Space dn` | Step over (next) |
| `Space di` | Step into |
| `Space du` | Step out (up) |
| `Space dq` | Close DAP UI |

## Git

| Key | Action |
|-----|--------|
| `]c` / `[c` | Next / previous hunk |
| `Space hs` | Stage hunk |
| `Space hr` | Reset hunk |
| `Space hp` | Preview hunk |
| `Space hb` | Blame line |
| `:Git blame` | Full file blame |
| `:Git diff` | Git diff |
| `:Git log` | Git log |
| `:Git push` | Push |
| `:Git pull` | Pull |

## Clipboard

System clipboard is synced — `y`/`d`/`p` work with Cmd+C/Cmd+V.

| Key | Action |
|-----|--------|
| `yy` | Copy line |
| `yiw` | Copy word |
| `v` then `y` | Select then copy |
| `p` / `P` | Paste after / before |
| `dd` | Cut line |

## Go Commands

| Command | Action |
|---------|--------|
| `:GoAddTags` | Add `json` tags to struct fields |
| `:GoAddTags yaml` | Add `yaml` tags |
| `:GoRemoveTags` | Remove `json` tags |
| `:GoRemoveTags yaml` | Remove `yaml` tags |
| `:GoTestFunc` | Generate test for function under cursor |
| `:GoTestAll` | Generate tests for all functions in file |
| `:GoPlay` | Share current file to Go Playground (URL copied) |

## Automatic

- Organizes imports on save (goimports)
- Formats code on save (gofumpt)
- Auto-saves all files on focus lost
- Go stdlib and module cache files are read-only

## Other

| Key | Action |
|-----|--------|
| `Space cc` | Open Claude Code |
| `Space ?` | Open this cheatsheet |
| `Space` | Which-key popup (shows all keybindings) |
| `C-\ C-n` | Exit terminal mode |
| `:PluginUpdate` | Update all plugins |
