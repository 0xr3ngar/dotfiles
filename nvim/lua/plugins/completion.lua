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
        ["<Tab>"] = cmp.mapping(function(fallback)
            local suggestion = require("supermaven-nvim.completion_preview")
            if suggestion.has_suggestion() then
                suggestion.on_accept_suggestion()
            elseif cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
})

require("supermaven-nvim").setup({
    keymaps = {
        accept_suggestion = nil,
        accept_word = "<C-Right>",
        clear_suggestion = "<C-]>",
    },
})
