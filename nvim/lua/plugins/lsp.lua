require("mason").setup()

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Define LSP configurations using the new vim.lsp API (Neovim 0.11+)
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
})

vim.lsp.config('ts_ls', {
    capabilities = capabilities,
})

vim.lsp.config('eslint', {
    capabilities = capabilities,
})

vim.lsp.config('clangd', {
    capabilities = capabilities,
})

vim.lsp.config('pylsp', {
    capabilities = capabilities,
    cmd = { "uv", "run", "--with", "python-lsp-server", "pylsp" },
    root_dir = function(fname)
        return vim.fs.root(fname, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt" })
    end,
})

-- Enable the servers
vim.lsp.enable({ 'lua_ls', 'ts_ls', 'eslint', 'clangd', 'pylsp' })

vim.keymap.set("n", "pd", "<CMD>Glance implementations<CR>")
