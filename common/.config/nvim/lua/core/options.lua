vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Unused providers (silence health noise)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "_" }
vim.opt.fillchars = { eob = " " }
vim.opt.scrolloff = 8
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
vim.opt.autoread = true

-- Wayland system clipboard (shared with terminal / browser)
if vim.fn.executable("wl-copy") == 1 then
    vim.g.clipboard = {
        name = "wl-clipboard",
        copy = {
            ["+"] = { "wl-copy", "--type", "text/plain" },
            ["*"] = { "wl-copy", "--primary", "--type", "text/plain" },
        },
        paste = {
            ["+"] = { "wl-paste", "--no-newline" },
            ["*"] = { "wl-paste", "--no-newline", "--primary" },
        },
        cache_enabled = 1,
    }
end
