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

vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end)
vim.keymap.set({ "o", "x" }, "r", function() require("flash").treesitter_search() end)
vim.keymap.set({ "c" }, "<c-s>", function() require("flash").toggle() end)
