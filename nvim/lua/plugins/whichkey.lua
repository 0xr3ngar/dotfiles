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

    -- Surround (mini.surround)
    { "sa",          desc = "Add surrounding",          mode = { "n", "v" } },
    { "sd",          desc = "Delete surrounding" },
    { "sr",          desc = "Replace surrounding" },
    { "sf",          desc = "Find surrounding right" },
    { "sF",          desc = "Find surrounding left" },
    { "sh",          desc = "Highlight surrounding" },

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
