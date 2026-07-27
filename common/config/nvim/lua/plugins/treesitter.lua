local treesitter = require("nvim-treesitter")

local parsers = {
    "c",
    "javascript",
    "json",
    "jsonc",
    "lua",
    "markdown",
    "python",
    "query",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
}

treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter/runtime")

local languages = {
    "c",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "lua",
    "markdown",
    "python",
    "query",
    "typescript",
    "typescriptreact",
    "vim",
    "vimdoc",
}

vim.api.nvim_create_user_command("TSInstallConfigured", function()
    treesitter.install(parsers)
end, {})

vim.api.nvim_create_autocmd("FileType", {
    pattern = languages,
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
