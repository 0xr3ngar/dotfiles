require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "ts_ls", "eslint", "clangd" },
    automatic_enable = true,
})

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

local servers = {
    { name = "lua_ls", executable = "lua-language-server" },
    { name = "ts_ls",  executable = "typescript-language-server" },
    { name = "eslint", executable = "vscode-eslint-language-server" },
    { name = "clangd", executable = "clangd" },
    { name = "pylsp",  executable = "uv" },
}

local enabled_servers = {}

for _, server in ipairs(servers) do
    if vim.fn.executable(server.executable) == 1 then
        table.insert(enabled_servers, server.name)
    end
end

vim.lsp.enable(enabled_servers)

vim.keymap.set("n", "pd", "<CMD>Glance implementations<CR>")
