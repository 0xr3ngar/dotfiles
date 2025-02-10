local builtin = require('telescope.builtin')

vim.keymap.set('n', "<leader>pf", builtin.find_files, {})
vim.keymap.set('n', "<leader>pg", builtin.git_files, {})

vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")


vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-h>", function () ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function () ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function () ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function () ui.nav_file(4) end)


vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.on_attach()


lsp.setup()

lsp.ensure_installed({
    'ts-ls',
    'biome',
})


