local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pv', ':NvimTreeFindFileToggle<CR>', {
        noremap = true
})

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

vim.keymap.set("n", "<leader>t", ":terminal<CR>", { noremap = true, silent = true })

local function run_npm_format_fix_and_reload()
        local current_file = vim.fn.expand('%')
        local project_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

        if not string.find(project_root, "ProcessMining") then
                vim.notify("Project root does not contain 'Process_Mining', skipping format:fix", vim.log.levels.WARN)
                return
        end

        if not project_root or project_root == "" then
                vim.notify("Could not find project root", vim.log.levels.ERROR)
                return
        end

        local command = "npm run format:fix"

        vim.fn.jobstart(command, {
                on_exit = function(job, return_val)
                        if return_val == 0 then
                                vim.cmd("edit!") -- Reload the current buffer
                                vim.notify("npm run format:fix and reload completed", vim.log.levels.INFO)
                        else
                                vim.notify("npm run format:fix failed!", vim.log.levels.ERROR)
                        end
                end,
        })
end

vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = { '*.js', '*.jsx', '*.ts', '*.tsx', '*.json' },
        callback = run_npm_format_fix_and_reload,
})

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


vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
vim.g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'} -- customize lazygit popup window border characters
vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed

vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
vim.g.lazygit_config_file_path = '' -- custom config file path
-- OR
vim.g.lazygit_config_file_path = {} -- table of custom config file paths

vim.g.lazygit_on_exit_callback = nil -- optional function callback when exiting lazygit (useful for example to refresh some UI elements after lazy git has made some changes)
