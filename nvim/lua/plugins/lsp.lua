require("mason").setup()

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.lua_ls.setup({ capabilities = capabilities })
lspconfig.ts_ls.setup({ capabilities = capabilities })
lspconfig.eslint.setup({ capabilities = capabilities })
lspconfig.clangd.setup({ capabilities = capabilities })
lspconfig.pylsp.setup({
    capabilities = capabilities,
    root_dir = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt"),
    cmd = { "uv", "run", "--with", "python-lsp-server", "pylsp" },
})

vim.keymap.set("n", "pd", "<CMD>Glance implementations<CR>")
