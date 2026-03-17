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

## Go Commands (go.nvim)

| Command | Action |
|---------|--------|
| `:GoAddTag json` | Add `json` tags to struct fields |
| `:GoRmTag json` | Remove `json` tags |
| `:GoTestFunc` | Run test for function under cursor |
| `:GoTest` | Run all tests |
| `:GoImpl` | Generate interface implementation |
| `:GoFillStruct` | Fill struct with default values |
| `:GoFillSwitch` | Fill switch cases |
| `:GoIfErr` | Generate `if err != nil` block |
| `:GoCoverage` | Run tests with coverage highlight |
| `:GoDoc` | Show Go doc for symbol |
| `:GoPlay` | Share current file to Go Playground (URL copied) |

## Treesitter Textobjects

| Key | Action |
|-----|--------|
| `vaf` / `vif` | Select outer/inner function |
| `vac` / `vic` | Select outer/inner class/struct |
| `vaa` / `via` | Select outer/inner parameter |
| `]m` / `[m` | Next / previous function start |
| `]M` / `[M` | Next / previous function end |
| `]a` / `[a` | Next / previous parameter |
| `Space a` | Swap parameter with next |
| `Space A` | Swap parameter with previous |

## Trouble (diagnostics panel)

| Key | Action |
|-----|--------|
| `Space xx` | Toggle workspace diagnostics |
| `Space xd` | Toggle buffer diagnostics |
| `Space xl` | Toggle loclist |
| `Space xq` | Toggle quickfix |

## Surround (nvim-surround)

| Key | Action |
|-----|--------|
| `ysiw"` | Surround word with `"` |
| `cs"'` | Change `"` to `'` |
| `ds"` | Delete surrounding `"` |
| `S"` (visual) | Surround selection with `"` |

## TODO Comments

| Key | Action |
|-----|--------|
| `Space ft` | Search TODOs via Telescope |
| `]t` / `[t` | Next / previous TODO comment |

## Automatic

- Organizes imports on save (goimports)
- Formats code on save (gofumpt)
- Auto-saves all files on focus lost
- Go stdlib and module cache files are read-only

## Other

| Key | Action |
|-----|--------|
| `Space cc` | Toggle Claude Code (floating terminal) |
| `:ClaudeCodeContinue` | Resume most recent conversation |
| `:ClaudeCodeResume` | Interactive conversation picker |
| `Space ?` | Open this cheatsheet |
| `Space` | Which-key popup (shows all keybindings) |
| `C-\ C-n` | Exit terminal mode |
| `:PluginUpdate` | Update all plugins |
