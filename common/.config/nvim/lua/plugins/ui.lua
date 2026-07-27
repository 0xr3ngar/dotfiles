local smear = require("smear_cursor")

if vim.fn.has("mac") == 1 then
    vim.cmd.colorscheme("ember")
    smear.setup({
        cursor_color = "#e08060",
        normal_bg = "none",
        smear_between_buffers = true,
        smear_between_neighbor_lines = true,
        distance_stop_animating = 0.5,
    })
else
    require("core.godking").apply()
    smear.setup({
        cursor_color = "#d33355",
        normal_bg = "none",
        smear_between_buffers = true,
        smear_between_neighbor_lines = true,
        distance_stop_animating = 0.5,
    })
end
