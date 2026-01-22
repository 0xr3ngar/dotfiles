require("smear_cursor").setup({
    cursor_color = "#ff6b6b",
    normal_bg = "none",
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    legacy_computing_symbols_support = false,
    distance_stop_animating = 0.5,
    hide_target_hack = false,
})

require("snacks").setup({
    input = {},
    picker = {},
    terminal = {},
})

vim.cmd("colorscheme vesper")

local transparent_groups = {
    "Normal",
    "NormalFloat",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",
    "LineNr",
    "CursorLineNr",
    "StatusLine",
    "StatusLineNC",
}

for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
end
