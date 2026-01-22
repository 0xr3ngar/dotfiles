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

vim.keymap.set({ "n", "x" }, "<M-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
    { desc = "Ask opencode" })
vim.keymap.set({ "n", "x" }, "<M-x>", function() require("opencode").select() end, { desc = "Execute opencode action" })
vim.keymap.set({ "n", "t" }, "<M-.>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
    { expr = true, desc = "Add range to opencode" })
vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
    { expr = true, desc = "Add line to opencode" })
vim.keymap.set("n", "<M-u>", function() require("opencode").command("session.half.page.up") end,
    { desc = "opencode half page up" })
vim.keymap.set("n", "<M-d>", function() require("opencode").command("session.half.page.down") end,
    { desc = "opencode half page down" })
