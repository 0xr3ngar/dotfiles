local cmp = require("cmp")

cmp.setup({
    completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp", group_index = 2 },
        { name = "buffer",   group_index = 2 },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
})
