-- General
vim.keymap.set("n", "<Esc>", ":noh<CR>", { silent = true })
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>o", ":update<CR>:source<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)

-- Movement
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "]q", ":cnext<CR>")
vim.keymap.set("n", "[q", ":cprev<CR>")

-- Visual Mode
vim.keymap.set("v", "<leader>rn", '"hy:%s/<C-r>h//g<left><left>')
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "y", "ygv<Esc>")

-- Windows
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

-- Terminal
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
