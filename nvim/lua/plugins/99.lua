local _99 = require("99")

_99.setup({
    md_files = {
        "AGENT.md",
    },
    model = "opencode/big-pickle",
    completion = {
        source = "cmp",
    },
})

vim.keymap.set("n", "<leader>af", function()
    _99.fill_in_function()
end, { desc = "99: Fill in function" })

vim.keymap.set("v", "<leader>av", function()
    _99.visual()
end, { desc = "99: Visual prompt" })

vim.keymap.set("n", "<leader>as", function()
    _99.stop_all_requests()
end, { desc = "99: Stop all requests" })

vim.keymap.set("n", "<leader>am", function()
    _99.select_model()
end, { desc = "99: Select model" })
