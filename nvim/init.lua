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
vim.opt.listchars = "tab:..,trail:.,nbsp:_,space:·"
vim.opt.scrolloff = 20
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = 'yes'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.undofile = true

-- Plugins
vim.pack.add({
    { src = "https://github.com/namrabtw/rusty.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" }, -- Required by telescope
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/folke/flash.nvim" },
    { src = "https://github.com/shortcuts/no-neck-pain.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/zbirenbaum/copilot.lua" },
    { src = "https://github.com/zbirenbaum/copilot-cmp" },
    { src = "https://github.com/sainnhe/everforest" },
    { src = "https://github.com/ThePrimeagen/harpoon" },
    { src = "https://github.com/dnlhc/glance.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/sphamba/smear-cursor.nvim" },
})

vim.cmd('packloadall')


require('smear_cursor').setup({
    cursor_color = "#ff6b6b",
    normal_bg = "#232A2E",
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    legacy_computing_symbols_support = false,
    distance_stop_animating = 0.5,
    hide_target_hack = false,
})

require('nvim-web-devicons').setup({
    override = {
        zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
        }
    },
    color_icons = true,
    default = true,
    strict = true,
})

require('copilot').setup({
    suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
            accept = false,
            accept_word = "<C-Right>",
            dismiss = "<C-]>",
        },
    },
    panel = { enabled = false },
})


require('copilot_cmp').setup()

require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
    },
    pickers = {
        find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
    }
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
        search = {
            enabled = true,
        },
        char = {
            enabled = true,
            jump_labels = true,
        },
    },
})


require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "javascript" },

    sync_install = false,

    auto_install = true,

    highlight = {
        enable = true,
        disable = false,
        additional_vim_regex_highlighting = false,
    },
}

-- center cuz it is annoying to have text all the way to the left
require("no-neck-pain").setup({
    width = 120,
    autocmds = {
        enableOnVimEnter = true,
        enableOnTabEnter = true,
        skipEnteringNoNeckPainBuffer = true,
    },
    buffers = {
        colors = {
            background = "#232A2E",
        },
        bo = {
            filetype = "no-neck-pain",
            buftype = "nofile",
            bufhidden = "hide",
            buflisted = false,
            swapfile = false,
        },
        wo = {
            number = false,
            relativenumber = false,
            signcolumn = "no",
            statuscolumn = "",
        },
    },
})

local wk = require("which-key")
wk.add({
    -- Leader mappings
    { "<leader>?",   desc = "Show cheatsheet" },
    { "<leader>a",   desc = "Add file to Harpoon" },
    { "<leader>d",   desc = "Show diagnostics" },
    { "<leader>e",   desc = "Oil file explorer" },
    { "<leader>o",   desc = "Source config" },
    { "<leader>q",   desc = "Diagnostics list" },
    { "<leader>h",   desc = "Horizontal split" },
    { "<leader>v",   desc = "Vertical split" },

    -- Git group
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
    { "<leader>gw",  desc = "Mark resolved" },

    -- Git subgroups
    { "<leader>gpu", desc = "Push new branch" },
    { "<leader>gr",  group = "rebase" },
    { "<leader>gri", desc = "Interactive rebase" },
    { "<leader>grc", desc = "Continue rebase" },
    { "<leader>gra", desc = "Abort rebase" },
    { "<leader>gc",  group = "commit" },
    { "<leader>gcf", desc = "Fixup HEAD" },
    { "<leader>gca", desc = "Amend no edit" },

    -- Project/Find group
    { "<leader>p",   group = "project/find" },
    { "<leader>pf",  desc = "Find files" },
    { "<leader>pg",  desc = "Git files" },
    { "<leader>ps",  desc = "Live grep" },
    { "<leader>pb",  desc = "Buffers" },
    { "<leader>ph",  desc = "Help tags" },

    -- LSP group
    { "<leader>l",   group = "lsp" },
    { "<leader>lf",  desc = "Format buffer" },

    -- Rename/Replace group
    { "<leader>r",   group = "rename/replace" },
    { "<leader>rn",  desc = "Search/replace (visual)", mode = "v" },

    -- Terminal group
    { "<leader>t",   group = "terminal" },
    { "<leader>tf",  desc = "Floating terminal" },

    -- Non-leader mappings
    { "K",           desc = "Hover info" },
    { "gd",          desc = "Go to definition" },
    { "gA",          desc = "Find all references" },
    { "s",           desc = "Flash jump",              mode = { "n", "v", "o" } },
    { "S",           desc = "Flash treesitter",        mode = { "n", "v", "o" } },
    { "r",           desc = "Flash treesitter search", mode = { "v", "o" } },

    -- Diagnostics navigation
    { "]d",          desc = "Next diagnostic" },
    { "[d",          desc = "Previous diagnostic" },

    -- Control mappings
    { "<C-e>",       desc = "Toggle Harpoon menu" },
    { "<C-1>",       desc = "Harpoon file 1" },
    { "<C-2>",       desc = "Harpoon file 2" },
    { "<C-3>",       desc = "Harpoon file 3" },
    { "<C-4>",       desc = "Harpoon file 4" },
    { "<C-h>",       desc = "Window left" },
    { "<C-j>",       desc = "Window down" },
    { "<C-k>",       desc = "Window up" },
    { "<C-l>",       desc = "Window right" },
    { "<C-d>",       desc = "Page down centered" },
    { "<C-u>",       desc = "Page up centered" },

    -- Visual mode specific
    { "J",           desc = "Move selection down",     mode = "v" },
    { "K",           desc = "Move selection up",       mode = "v" },
    { "<",           desc = "Indent left",             mode = "v" },
    { ">",           desc = "Indent right",            mode = "v" },
})

local cmp = require('cmp')
cmp.setup({
    completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
    },
    sources = cmp.config.sources({
        { name = 'copilot',  group_index = 2 },
        { name = 'nvim_lsp', group_index = 2 },
        { name = 'buffer',   group_index = 2 },
    }),
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
            -- Check if copilot has a suggestion
            local copilot_suggestion = require('copilot.suggestion')
            if copilot_suggestion.is_visible() then
                copilot_suggestion.accept()
            elseif cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})

-- LSP setup
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup({ capabilities = capabilities })
lspconfig.ts_ls.setup({ capabilities = capabilities })
lspconfig.eslint.setup({ capabilities = capabilities })
lspconfig.clangd.setup({ capabilities = capabilities })

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- Harpoon
vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end)

-- General keymaps
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', 'pd', '<CMD>Glance implementations<CR>')

-- Telescope keymaps
vim.keymap.set('n', '<leader>pf', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>pg', '<cmd>Telescope git_files<cr>')
vim.keymap.set('n', '<leader>ps', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>pb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>ph', '<cmd>Telescope help_tags<cr>')
vim.keymap.set('n', '<leader>e', ":Oil<CR>")
vim.keymap.set('n', 'gA', '<cmd>Telescope lsp_references<cr>', { desc = 'Find all references' })

-- Movement
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Visual mode
vim.keymap.set("v", "<leader>rn", "\"hy:%s/<C-r>h//g<left><left>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Window management
vim.keymap.set('n', '<leader>v', ':vsplit<CR>')
vim.keymap.set('n', '<leader>h', ':split<CR>')
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Git keymaps (Fugitive)
vim.keymap.set("n", "<leader>gs", ":Git<CR>")                         -- Git status
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")                   -- Git blame
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>")                  -- Diff file
vim.keymap.set("n", "<leader>gl", ":Git log --oneline<CR>")           -- Git log
vim.keymap.set("n", "<leader>gp", ":Git push<CR>")                    -- Push
vim.keymap.set("n", "<leader>gP", ":Git pull<CR>")                    -- Pull
vim.keymap.set("n", "<leader>gf", ":Git push --force-with-lease<CR>") -- Force push (safe)
vim.keymap.set("n", "<leader>gpu", ":Git push -u origin HEAD<CR>")    -- Push new branch

-- Merge conflicts
vim.keymap.set("n", "<leader>gm", ":Gvdiffsplit!<CR>") -- 3-way merge view
vim.keymap.set("n", "<leader>gh", ":diffget //2<CR>")  -- Take left/ours (HEAD)
vim.keymap.set("n", "<leader>gl", ":diffget //3<CR>")  -- Take right/theirs
vim.keymap.set("n", "<leader>gw", ":Gwrite!<CR>")      -- Mark conflict resolved

-- Flash navigation
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end)
vim.keymap.set({ "o", "x" }, "r", function() require("flash").treesitter_search() end)
vim.keymap.set({ "c" }, "<c-s>", function() require("flash").toggle() end)

-- Terminal
vim.keymap.set('n', '<leader>tf', function()
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
    })

    vim.cmd('terminal')
    vim.cmd('startinsert')
end)

--Autocmds
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format()
    end,
})

vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        local root_markers = { '.git', 'package.json', 'Cargo.toml', 'go.mod' }
        local root = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1])
        if root then vim.cmd('cd ' .. root) end
    end
})

vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
    callback = function()
        if vim.bo.modified and vim.bo.buftype == '' then
            vim.cmd('silent! write')
        end
    end
})

vim.cmd("colorscheme everforest")
