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

vim.keymap.set("n", "<leader>pf", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>pg", "<cmd>Telescope git_files<cr>")
vim.keymap.set("n", "<leader>ps", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>pb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>ph", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>pt", "<cmd>Telescope colorscheme<cr>")
vim.keymap.set("n", "gA", "<cmd>Telescope lsp_references<cr>")
