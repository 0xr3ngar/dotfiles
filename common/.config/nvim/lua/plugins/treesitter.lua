local treesitter = require("nvim-treesitter")

local parsers = {
    "c",
    "javascript",
    "json",
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

local function parsers_missing()
    local parser_dir = vim.fn.stdpath("data") .. "/site/parser"
    for _, lang in ipairs(parsers) do
        local so = parser_dir .. "/" .. lang .. ".so"
        if vim.fn.filereadable(so) == 0 then
            return true
        end
    end
    return false
end

vim.api.nvim_create_user_command("TSInstallConfigured", function()
    if vim.fn.executable("tree-sitter") == 0 then
        vim.notify("tree-sitter CLI missing — pacman -S tree-sitter-cli", vim.log.levels.ERROR)
        return
    end
    treesitter.install(parsers)
end, {})

-- Install parsers once if missing (needs tree-sitter CLI)
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        if not parsers_missing() then
            return
        end
        if vim.fn.executable("tree-sitter") == 0 then
            vim.notify("nvim: install tree-sitter-cli to enable syntax highlighting", vim.log.levels.WARN)
            return
        end
        vim.notify("Installing treesitter parsers…", vim.log.levels.INFO)
        treesitter.install(parsers)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = languages,
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
