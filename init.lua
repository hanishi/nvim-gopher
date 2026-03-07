-- Options
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.lazyredraw = true
-- Go uses tabs
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end,
})

-- Dashboard
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Project stats
local function project_stats()
  local stats = {}
  local gomod_path = vim.fn.glob("go.mod")
  if gomod_path == "" then
    return { "   No go.mod found — open a Go project to see stats" }
  end

  -- Module name
  local first_line = vim.fn.readfile(gomod_path, "", 1)[1] or ""
  local mod = first_line:match("^module%s+(.+)")
  if mod then
    table.insert(stats, "   Module     " .. mod)
  end

  -- Count .go files, test files, and lines
  local go_files = vim.fn.globpath(".", "**/*.go", false, true)
  local src_files = 0
  local test_files = 0
  local total_lines = 0
  for _, f in ipairs(go_files) do
    if f:match("_test%.go$") then
      test_files = test_files + 1
    else
      src_files = src_files + 1
    end
    local lines = vim.fn.readfile(f)
    total_lines = total_lines + #lines
  end
  table.insert(stats, "   Files      " .. src_files .. " source, " .. test_files .. " test")
  table.insert(stats, "   Lines      " .. total_lines)

  -- Count packages (directories containing .go files)
  local pkgs = {}
  for _, f in ipairs(go_files) do
    local dir = vim.fn.fnamemodify(f, ":h")
    pkgs[dir] = true
  end
  local pkg_count = 0
  for _ in pairs(pkgs) do pkg_count = pkg_count + 1 end
  table.insert(stats, "   Packages   " .. pkg_count)

  -- Count dependencies from go.mod
  local dep_count = 0
  local mod_lines = vim.fn.readfile(gomod_path)
  local in_require = false
  for _, line in ipairs(mod_lines) do
    if line:match("^require%s*%(") then
      in_require = true
    elseif in_require and line:match("^%)") then
      in_require = false
    elseif in_require and line:match("%S") then
      dep_count = dep_count + 1
    elseif line:match("^require%s+[^(]") then
      dep_count = dep_count + 1
    end
  end
  table.insert(stats, "   Deps       " .. dep_count)

  -- Go version from go.mod
  for _, line in ipairs(mod_lines) do
    local ver = line:match("^go%s+(.+)")
    if ver then
      table.insert(stats, "   Go         " .. ver)
      break
    end
  end

  return stats
end

-- Build header
local header = { "   ʕ◔ϖ◔ʔ" }
table.insert(header, "")
for _, line in ipairs(project_stats()) do
  table.insert(header, line)
end

dashboard.section.header.val = header
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file",    "<cmd>Telescope find_files<CR>"),
  dashboard.button("g", "  Live grep",    "<cmd>Telescope live_grep<CR>"),
  dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
  dashboard.button("n", "  File tree",    "<cmd>NvimTreeToggle<CR>"),
  dashboard.button("?", "  Cheatsheet",   "<cmd>tabe " .. vim.fn.stdpath("config") .. "/cheatsheet.md<CR>"),
  dashboard.button("q", "  Quit",         "<cmd>qa<CR>"),
}
dashboard.section.header.opts.hl = "Type"
dashboard.section.buttons.opts.hl = "Keyword"
dashboard.section.footer.val = ""
alpha.setup(dashboard.config)

-- Tabline (show tab numbers + filenames at the top)
vim.opt.showtabline = 2

-- Mark Go stdlib and module cache files as read-only
local goroot = os.getenv("GOROOT") or vim.fn.system("go env GOROOT"):gsub("%s+$", "")
local gomodcache = os.getenv("GOMODCACHE") or vim.fn.system("go env GOMODCACHE"):gsub("%s+$", "")
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.go",
  callback = function(ev)
    local path = vim.api.nvim_buf_get_name(ev.buf)
    if path:find(goroot, 1, true) or path:find(gomodcache, 1, true) then
      vim.bo[ev.buf].readonly = true
      vim.bo[ev.buf].modifiable = false
    end
  end,
})

-- Auto-save on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    vim.cmd("silent! wall")
  end,
})

-- File tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local nvim_tree_api = require("nvim-tree.api")
local function nvim_tree_on_attach(bufnr)
  local function opts(desc)
    return { buffer = bufnr, noremap = true, silent = true, desc = "nvim-tree: " .. desc }
  end
  -- Load all default keymaps first
  nvim_tree_api.config.mappings.default_on_attach(bufnr)
  -- Disable navigating above project root
  vim.keymap.set("n", "-", "", opts("Disabled"))
  vim.keymap.set("n", "<BS>", "", opts("Disabled"))
  vim.keymap.set("n", "~", "", opts("Disabled"))

  -- Override Enter to always open files in a new tab
  vim.keymap.set("n", "<CR>", function()
    local node = nvim_tree_api.tree.get_node_under_cursor()
    if not node then
      return
    elseif node.name == ".." then
      return
    elseif node.type == "directory" then
      nvim_tree_api.node.open.edit()
    else
      local path = node.absolute_path
      -- Check if file is already open in a tab
      for _, tabid in ipairs(vim.api.nvim_list_tabpages()) do
        for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
          local bufid = vim.api.nvim_win_get_buf(winid)
          if vim.api.nvim_buf_get_name(bufid) == path then
            vim.api.nvim_set_current_tabpage(tabid)
            vim.api.nvim_set_current_win(winid)
            return
          end
        end
      end
      -- Not open yet, create new tab
      vim.cmd("wincmd l")
      vim.cmd("tabe " .. vim.fn.fnameescape(path))
    end
  end, opts("Open in new tab"))
end
require("nvim-tree").setup({
  view = { width = 30 },
  filters = { dotfiles = false },
  git = { enable = true },
  tab = { sync = { open = true, close = true } },
  actions = { open_file = { quit_on_open = false } },
  on_attach = nvim_tree_on_attach,
})
vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>N", "<cmd>NvimTreeFindFile<CR>")

-- Treesitter (built-in in Neovim 0.11+, nvim-treesitter handles parser installs)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gosum", "lua", "json", "yaml", "toml", "markdown", "bash", "python", "javascript", "typescript", "html", "css", "dockerfile" },
  callback = function()
    vim.treesitter.start()
  end,
})

-- LSP
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.work", ".git" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },
      staticcheck = true,
      gofumpt = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})
vim.lsp.enable("gopls")

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,      opts)
    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,     opts)
    vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,  opts)
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,           opts)
    vim.keymap.set("n", "<C-k>",      vim.lsp.buf.signature_help,  opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,     opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,          opts)
  end,
})

-- Diagnostics
vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = "●" },
  signs = true,
  underline = true,
  severity_sort = true,
  float = { border = "rounded" },
})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Format + organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    -- Organize imports via gopls code action
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
      for _, action in pairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
        elseif action.command then
          vim.lsp.buf.execute_command(action.command)
        end
      end
    end
    -- Format
    vim.lsp.buf.format({ async = false })
  end,
})

-- Snippets
local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

luasnip.add_snippets("go", {
  s("iferr", {
    t("if err != nil {"),
    t({ "", "\t" }), i(1, "return err"),
    t({ "", "}" }),
  }),
  s("tt", {
    t("tests := []struct {"),
    t({ "", "\tname string" }),
    t({ "", "\t" }), i(1),
    t({ "", "}{" }),
    t({ "", "\t{" }),
    t({ "", '\t\tname: "' }), i(2, "test case"), t('",'),
    t({ "", "\t}," }),
    t({ "", "}" }),
    t({ "", "for _, tt := range tests {" }),
    t({ "", '\tt.Run(tt.name, func(t *testing.T) {' }),
    t({ "", "\t\t" }), i(3),
    t({ "", "\t})" }),
    t({ "", "}" }),
  }),
  s("errw", {
    t('fmt.Errorf("'), i(1, "message"), t(': %w", '), i(2, "err"), t(")"),
  }),
})

-- Completion
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<Tab>"]     = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"]   = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-d>"]     = cmp.mapping.scroll_docs(4),
    ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

-- Autopairs
local autopairs = require("nvim-autopairs")
autopairs.setup({})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)
vim.keymap.set("n", "gr",         builtin.lsp_references)
vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols)
vim.keymap.set("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols)

-- Neotest
require("neotest").setup({
  adapters = { require("neotest-go") },
})
vim.keymap.set("n", "<leader>tr", function() require("neotest").run.run() end)
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end)
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end)
vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end)

-- DAP
require("dap-go").setup()
local dapui = require("dapui")
dapui.setup()

-- Lock all Go buffers during debugging, unlock when done
local pre_debug_modifiable = {}
local function lock_buffers()
  pre_debug_modifiable = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "go" then
      pre_debug_modifiable[buf] = vim.bo[buf].modifiable
      vim.bo[buf].modifiable = false
      vim.bo[buf].readonly = true
    end
  end
end
local function unlock_buffers()
  for buf, was_modifiable in pairs(pre_debug_modifiable) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.bo[buf].modifiable = was_modifiable
      vim.bo[buf].readonly = not was_modifiable
    end
  end
  pre_debug_modifiable = {}
end

require("dap").listeners.after.event_initialized["dapui_config"] = function()
  lock_buffers()
  dapui.open()
end
local function close_dapui_and_restore()
  dapui.close()
  unlock_buffers()
  vim.defer_fn(function()
    vim.cmd("NvimTreeClose")
    vim.cmd("NvimTreeOpen")
    vim.cmd("wincmd l")
  end, 100)
end
require("dap").listeners.before.event_terminated["dapui_config"]  = close_dapui_and_restore
require("dap").listeners.before.event_exited["dapui_config"]      = close_dapui_and_restore
vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint)
vim.keymap.set("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end)
vim.keymap.set("n", "<leader>dc", require("dap").continue)
vim.keymap.set("n", "<leader>dt", require("dap-go").debug_test)
vim.keymap.set("n", "<leader>dn", require("dap").step_over)
vim.keymap.set("n", "<leader>di", require("dap").step_into)
vim.keymap.set("n", "<leader>du", require("dap").step_out)
vim.keymap.set("n", "<leader>dq", close_dapui_and_restore)

-- Gitsigns
require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "]c", function() gs.nav_hunk("next") end, opts)
    vim.keymap.set("n", "[c", function() gs.nav_hunk("prev") end, opts)
    vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
    vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
    vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
    vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts)
  end,
})

-- Lualine
require("lualine").setup({
  options = { theme = "auto", icons_enabled = true },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- Which-key
require("which-key").setup({
  triggers = {
    { "<leader>", mode = "n" },
  },
})

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Tab keymaps
vim.keymap.set("n", "<leader>1", "1gt")
vim.keymap.set("n", "<leader>2", "2gt")
vim.keymap.set("n", "<leader>3", "3gt")
vim.keymap.set("n", "<leader>4", "4gt")
vim.keymap.set("n", "<leader>5", "5gt")
vim.keymap.set("n", "<leader>w", "<cmd>tabc<CR>")
vim.keymap.set("n", "<leader>]", "<cmd>tabn<CR>")
vim.keymap.set("n", "<leader>[", "<cmd>tabp<CR>")

-- Update all plugins
vim.api.nvim_create_user_command("PluginUpdate", function()
  local pack_dir = vim.fn.stdpath("data") .. "/site/pack/plugins/start"
  local dirs = vim.fn.globpath(pack_dir, "*", false, true)
  for _, dir in ipairs(dirs) do
    local name = vim.fn.fnamemodify(dir, ":t")
    vim.notify("Updating " .. name .. "...")
    vim.fn.system({ "git", "-C", dir, "pull", "--ff-only" })
  end
  vim.notify("All plugins updated. Restart Neovim.")
end, {})

-- Go struct tags
vim.api.nvim_create_user_command("GoAddTags", function(opts)
  local tag = opts.args ~= "" and opts.args or "json"
  local file = vim.fn.expand("%:p")
  local struct = vim.fn.expand("<cword>")
  local out = vim.fn.system({ "gomodifytags", "-file", file, "-struct", struct, "-add-tags", tag, "-w" })
  if vim.v.shell_error == 0 then
    vim.cmd("edit!")
  else
    vim.notify(out, vim.log.levels.ERROR)
  end
end, { nargs = "?", desc = "Add struct tags (default: json)" })

vim.api.nvim_create_user_command("GoRemoveTags", function(opts)
  local tag = opts.args ~= "" and opts.args or "json"
  local file = vim.fn.expand("%:p")
  local struct = vim.fn.expand("<cword>")
  local out = vim.fn.system({ "gomodifytags", "-file", file, "-struct", struct, "-remove-tags", tag, "-w" })
  if vim.v.shell_error == 0 then
    vim.cmd("edit!")
  else
    vim.notify(out, vim.log.levels.ERROR)
  end
end, { nargs = "?", desc = "Remove struct tags (default: json)" })

-- Go test generation
vim.api.nvim_create_user_command("GoTestFunc", function()
  local file = vim.fn.expand("%:p")
  local func = vim.fn.expand("<cword>")
  local out = vim.fn.system({ "gotests", "-only", func, "-w", file })
  if vim.v.shell_error == 0 then
    vim.cmd("edit!")
    vim.notify("Test generated for " .. func)
  else
    vim.notify(out, vim.log.levels.ERROR)
  end
end, { desc = "Generate test for function under cursor" })

vim.api.nvim_create_user_command("GoTestAll", function()
  local file = vim.fn.expand("%:p")
  local out = vim.fn.system({ "gotests", "-all", "-w", file })
  if vim.v.shell_error == 0 then
    vim.cmd("edit!")
    vim.notify("Tests generated for all functions")
  else
    vim.notify(out, vim.log.levels.ERROR)
  end
end, { desc = "Generate tests for all functions in file" })

-- Go Playground
vim.api.nvim_create_user_command("GoPlay", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local code = table.concat(lines, "\n")
  local result = vim.fn.system({ "curl", "-s", "--data-binary", code, "https://play.golang.org/share" })
  if vim.v.shell_error == 0 and result ~= "" then
    local url = "https://play.golang.org/p/" .. result
    vim.fn.setreg("+", url)
    vim.notify("Copied: " .. url)
  else
    vim.notify("Failed to share", vim.log.levels.ERROR)
  end
end, { desc = "Share current file to Go Playground" })

-- Claude Code
vim.keymap.set("n", "<leader>cc", function()
  vim.cmd("tabnew | terminal claude")
  vim.cmd("startinsert")
end)

-- Cheatsheet
vim.keymap.set("n", "<leader>?", function()
  vim.cmd("tabe " .. vim.fn.fnameescape(vim.fn.stdpath("config") .. "/cheatsheet.md"))
  vim.opt_local.bufhidden = "wipe"
end)
