-- Leader key
vim.g.mapleader = " "

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.swapfile = false
vim.opt.syntax = "enable"
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.list = true
vim.opt.listchars = { tab = "..", trail = ".", nbsp = "_", space = "." }
vim.opt.fillchars = { eob = " " }
vim.opt.scrolloff = 20
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = false
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Plugins
vim.pack.add({
    -- Core
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },

    -- Navigation
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/ThePrimeagen/harpoon" },
    { src = "https://github.com/folke/flash.nvim" },

    -- LSP & Completion
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/supermaven-inc/supermaven-nvim" },
    { src = "https://github.com/dnlhc/glance.nvim" },

    -- Treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },

    -- Git
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },

    -- UI
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/sphamba/smear-cursor.nvim" },

    -- AI
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/NickvanDyke/opencode.nvim" },

    -- Colorschemes
    { src = "https://github.com/namrabtw/rusty.nvim" },
    { src = "https://github.com/rebelot/kanagawa.nvim" },
    { src = "https://github.com/neanias/everforest-nvim" },
})

vim.cmd("packloadall")

-- Plugin Configs
require("smear_cursor").setup({
    cursor_color = "#ff6b6b",
    normal_bg = "none",
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    legacy_computing_symbols_support = false,
    distance_stop_animating = 0.5,
    hide_target_hack = false,
})

require("nvim-web-devicons").setup({
    override = {
        zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh",
        },
    },
    color_icons = true,
    default = true,
    strict = true,
})

require("supermaven-nvim").setup({
    keymaps = {
        accept_suggestion = nil,
        accept_word = "<C-Right>",
        clear_suggestion = "<C-]>",
    },
})

require("telescope").setup({
    defaults = {
        file_ignore_patterns = { "node_modules", ".git" },
    },
    pickers = {
        find_files = {
            find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
        },
    },
})

require("oil").setup({
    view_options = {
        show_hidden = true,
    },
})

require("mason").setup()

require("gitsigns").setup({
    current_line_blame = true,
})

require("flash").setup({
    search = {
        multi_window = true,
        forward = true,
    },
    jump = {
        jumplist = true,
        pos = "start",
        history = false,
        register = false,
    },
    modes = {
        search = { enabled = true },
        char = { enabled = true, jump_labels = true },
    },
})

require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "javascript", "typescript", "tsx" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        disable = false,
        additional_vim_regex_highlighting = false,
    },
})

require("snacks").setup({
    input = {},
    picker = {},
    terminal = {},
})

vim.o.autoread = true
vim.g.opencode_opts = {
    provider = {
        cmd = vim.fn.expand("~/.local/bin/opencode-wrapper"),
        enabled = "snacks",
        snacks = {
            env = {
                OPENCODE_CONFIG = vim.fn.expand("~/.config/opencode/opencode.json"),
            },
            win = {
                position = "left",
                width = 0.2,
                wo = {
                    winbar = "",
                },
                bo = {
                    filetype = "opencode_terminal",
                },
            },
        },
    },
}

-- Which-Key
local wk = require("which-key")
wk.add({
    -- Leader mappings
    { "<leader>a",   desc = "Add file to Harpoon" },
    { "<leader>d",   desc = "Show diagnostics" },
    { "<leader>e",   desc = "Oil file explorer" },
    { "<leader>o",   desc = "Source config" },
    { "<leader>q",   desc = "Diagnostics list" },
    { "<leader>s",   desc = "Horizontal split" },
    { "<leader>v",   desc = "Vertical split" },
    { "<leader>w",   desc = "Save file" },

    -- Git
    { "<leader>g",   group = "git" },
    { "<leader>gs",  desc = "Git status" },
    { "<leader>gb",  desc = "Git blame" },
    { "<leader>gd",  desc = "Diff file" },
    { "<leader>gl",  desc = "Git log" },
    { "<leader>gp",  desc = "Push" },
    { "<leader>gP",  desc = "Pull" },
    { "<leader>gf",  desc = "Force push (safe)" },
    { "<leader>gm",  desc = "3-way merge view" },
    { "<leader>gh",  desc = "Take ours (HEAD)" },
    { "<leader>gt",  desc = "Take theirs" },
    { "<leader>gw",  desc = "Mark resolved" },
    { "<leader>gpu", desc = "Push new branch" },

    -- Find
    { "<leader>p",   group = "find" },
    { "<leader>pf",  desc = "Find files" },
    { "<leader>pg",  desc = "Git files" },
    { "<leader>ps",  desc = "Live grep" },
    { "<leader>pb",  desc = "Buffers" },
    { "<leader>ph",  desc = "Help tags" },
    { "<leader>pt",  desc = "Colorschemes" },

    -- LSP
    { "<leader>l",   group = "lsp" },
    { "<leader>lf",  desc = "Format buffer" },

    -- Rename/Replace
    { "<leader>r",   group = "rename/replace" },
    { "<leader>rn",  desc = "LSP rename" },

    -- Code actions
    { "<leader>c",   group = "code" },
    { "<leader>ca",  desc = "Code action" },

    -- Terminal
    { "<leader>t",   group = "terminal" },
    { "<leader>tf",  desc = "Floating terminal" },

    -- opencode
    { "<M-a>",       desc = "Ask opencode",            mode = { "n", "x" } },
    { "<M-x>",       desc = "Execute opencode action", mode = { "n", "x" } },
    { "<M-.>",       desc = "Toggle opencode",         mode = { "n", "t" } },
    { "go",          desc = "Add range to opencode",   mode = { "n", "x" } },
    { "goo",         desc = "Add line to opencode" },
    { "<M-u>",       desc = "opencode half page up" },
    { "<M-d>",       desc = "opencode half page down" },

    -- Non-leader
    { "K",           desc = "Hover info" },
    { "gd",          desc = "Go to definition" },
    { "gi",          desc = "Go to implementation" },
    { "gt",          desc = "Go to type definition" },
    { "gA",          desc = "Find all references" },
    { "s",           desc = "Flash jump",              mode = { "n", "v", "o" } },
    { "S",           desc = "Flash treesitter",        mode = { "n", "v", "o" } },

    -- Diagnostics
    { "]d",          desc = "Next diagnostic" },
    { "[d",          desc = "Previous diagnostic" },
    { "]q",          desc = "Next quickfix" },
    { "[q",          desc = "Previous quickfix" },

    -- Harpoon
    { "<C-e>",       desc = "Toggle Harpoon menu" },
    { "<C-1>",       desc = "Harpoon file 1" },
    { "<C-2>",       desc = "Harpoon file 2" },
    { "<C-3>",       desc = "Harpoon file 3" },
    { "<C-4>",       desc = "Harpoon file 4" },

    -- Windows
    { "<C-h>",       desc = "Window left" },
    { "<C-j>",       desc = "Window down" },
    { "<C-k>",       desc = "Window up" },
    { "<C-l>",       desc = "Window right" },
    { "<C-d>",       desc = "Page down centered" },
    { "<C-u>",       desc = "Page up centered" },

    -- Visual
    { "J",           desc = "Move selection down",     mode = "v" },
    { "K",           desc = "Move selection up",       mode = "v" },
    { "<",           desc = "Indent left",             mode = "v" },
    { ">",           desc = "Indent right",            mode = "v" },
    { "<leader>rn",  desc = "Search/replace",          mode = "v" },
})

-- Completion
local cmp = require("cmp")
cmp.setup({
    completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp", group_index = 2 },
        { name = "buffer",   group_index = 2 },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
            local suggestion = require("supermaven-nvim.completion_preview")
            if suggestion.has_suggestion() then
                suggestion.on_accept_suggestion()
            elseif cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
})

-- LSP
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.lua_ls.setup({ capabilities = capabilities })
lspconfig.ts_ls.setup({ capabilities = capabilities })
lspconfig.eslint.setup({ capabilities = capabilities })
lspconfig.clangd.setup({ capabilities = capabilities })

vim.keymap.set({ "n", "x" }, "<M-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
    { desc = "Ask opencode" })
vim.keymap.set({ "n", "x" }, "<M-x>", function() require("opencode").select() end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "<M-.>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
    { expr = true, desc = "Add range to opencode" })
vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
    { expr = true, desc = "Add line to opencode" })
vim.keymap.set("n", "<M-u>", function() require("opencode").command("session.half.page.up") end,
    { desc = "opencode half page up" })
vim.keymap.set("n", "<M-d>", function() require("opencode").command("session.half.page.down") end,
    { desc = "opencode half page down" })

-- Harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end)

-- Keymaps: General
vim.keymap.set("n", "<Esc>", ":noh<CR>", { silent = true })
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>o", ":update<CR>:source<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "pd", "<CMD>Glance implementations<CR>")

-- Keymaps: Telescope
vim.keymap.set("n", "<leader>pf", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>pg", "<cmd>Telescope git_files<cr>")
vim.keymap.set("n", "<leader>ps", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>pb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>ph", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>pt", "<cmd>Telescope colorscheme<cr>")
vim.keymap.set("n", "<leader>e", ":Oil<CR>")
vim.keymap.set("n", "gA", "<cmd>Telescope lsp_references<cr>")

-- Keymaps: Movement
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "]q", ":cnext<CR>")
vim.keymap.set("n", "[q", ":cprev<CR>")

-- Keymaps: Visual Mode
vim.keymap.set("v", "<leader>rn", '"hy:%s/<C-r>h//g<left><left>')
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "y", "ygv<Esc>")

-- Keymaps: Windows
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")
vim.keymap.set("n", "<leader>s", ":split<CR>")
vim.keymap.set("n", "<S-C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<S-C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<S-C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<S-C-Right>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Keymaps: Git (Fugitive)
vim.keymap.set("n", "<leader>gs", ":Git<CR>")
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>")
vim.keymap.set("n", "<leader>gl", ":Git log --oneline<CR>")
vim.keymap.set("n", "<leader>gp", ":Git push<CR>")
vim.keymap.set("n", "<leader>gP", ":Git pull<CR>")
vim.keymap.set("n", "<leader>gf", ":Git push --force-with-lease<CR>")
vim.keymap.set("n", "<leader>gpu", ":Git push -u origin HEAD<CR>")
vim.keymap.set("n", "<leader>gm", ":Gvdiffsplit!<CR>")
vim.keymap.set("n", "<leader>gh", ":diffget //2<CR>")
vim.keymap.set("n", "<leader>gt", ":diffget //3<CR>")
vim.keymap.set("n", "<leader>gw", ":Gwrite!<CR>")

-- Keymaps: Flash
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end)
vim.keymap.set({ "o", "x" }, "r", function() require("flash").treesitter_search() end)
vim.keymap.set({ "c" }, "<c-s>", function() require("flash").toggle() end)

-- Keymaps: Terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")

vim.keymap.set("n", "<leader>tf", function()
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.cmd("terminal")
    vim.cmd("startinsert")
end)

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
            if client.supports_method("textDocument/formatting") then
                vim.lsp.buf.format({ timeout_ms = 2000 })
                return
            end
        end
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local root_markers = { ".git", "package.json", "Cargo.toml", "go.mod" }
        local root = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1])
        if root then
            vim.cmd("cd " .. root)
        end
    end,
})

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
    callback = function()
        if vim.bo.modified and vim.bo.buftype == "" then
            vim.cmd("silent! write")
        end
    end,
})

vim.cmd("colorscheme everforest")

local transparent_groups = {
    "Normal",
    "NormalFloat",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",
    "LineNr",
    "CursorLineNr",
    "StatusLine",
    "StatusLineNC",
}

for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
end
