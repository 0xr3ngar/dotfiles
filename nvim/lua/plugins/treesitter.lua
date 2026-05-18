local treesitter = require("nvim-treesitter")

treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter/runtime")

local languages = {
    "c",
    "javascript",
    "javascriptreact",
    "lua",
    "markdown",
    "python",
    "query",
    "typescript",
    "typescriptreact",
    "vim",
    "vimdoc",
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = languages,
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
