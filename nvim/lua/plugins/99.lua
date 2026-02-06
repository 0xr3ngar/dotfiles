local _99 = require("99")

_99.setup({
    md_files = {
        "AGENT.md",
    },
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

vim.keymap.set("n", "<leader>ar", function()
    _99.refactor_function()
end, { desc = "99: Refactor function" })

vim.keymap.set("n", "<leader>ae", function()
    _99.explain_function()
end, { desc = "99: Explain function" })

vim.keymap.set("n", "<leader>aE", function()
    _99.explain_function_prompt()
end, { desc = "99: Explain function with prompt" })

vim.keymap.set("n", "<leader>aes", function()
    _99.show_explanation_window()
end, { desc = "99: Show explanation in window" })

vim.keymap.set("n", "<leader>ac", function()
    _99.clear_explanations()
end, { desc = "99: Clear explanations" })
