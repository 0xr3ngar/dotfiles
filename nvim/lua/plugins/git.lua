require("gitsigns").setup({
    current_line_blame = true,
})

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
