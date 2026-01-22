require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "javascript", "typescript", "tsx" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        disable = false,
        additional_vim_regex_highlighting = false,
    },
})
