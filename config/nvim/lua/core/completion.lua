vim.opt.autocomplete = true
vim.opt.complete = { "." }
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.pumheight = 8
vim.opt.pummaxwidth = 50
vim.opt.pumborder = "rounded"

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("NativeCompletion", { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf)
            vim.bo[ev.buf].complete = "o,."
        end
    end,
})

vim.keymap.set("i", "<C-Space>", "<C-n>", { desc = "Complete" })
vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 0 then
        return "<CR>"
    end
    if vim.fn.complete_info({ "selected" }).selected == -1 then
        return "<C-n><C-y>"
    end
    return "<C-y>"
end, { expr = true, desc = "Accept completion or insert newline" })
