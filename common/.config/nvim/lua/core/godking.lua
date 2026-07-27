-- God-King palette (matches Arch alacritty / theme/colors.env)
-- Only applied on Linux; macOS keeps Ember.

local M = {}

local c = {
    bg = "#121012",
    bg_warm = "#24191d",
    bg_dim = "#0a0809",
    surface = "#2c2024",
    surface2 = "#3a2e32",
    surface3 = "#4a3c42",
    fg = "#c8c8d6",
    fg_dim = "#9a9aac",
    fg_muted = "#6e6e80",
    accent = "#d33355",
    accent_soft = "#e8456a",
    accent_dim = "#5a2436",
    accent_subtle = "#3a1822",
    ok = "#6e8a6a",
    warn = "#c9a06a",
    border = "#4a3c42",
    selection = "#5a2436",
    steel = "#a2a2b4",
}

function M.apply()
    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end
    vim.o.termguicolors = true
    vim.g.colors_name = "god-king"

    local hl = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    hl("Normal", { fg = c.fg, bg = c.bg })
    hl("NormalFloat", { fg = c.fg, bg = c.surface })
    hl("NormalNC", { fg = c.fg_dim, bg = c.bg })
    hl("FloatBorder", { fg = c.border, bg = c.surface })
    hl("WinSeparator", { fg = c.border })
    hl("LineNr", { fg = c.fg_muted })
    hl("CursorLineNr", { fg = c.accent, bold = true })
    hl("CursorLine", { bg = c.bg_warm })
    hl("Cursor", { fg = c.bg, bg = c.accent })
    hl("Visual", { bg = c.selection })
    hl("Search", { fg = c.bg, bg = c.warn })
    hl("IncSearch", { fg = c.bg, bg = c.accent })
    hl("MatchParen", { fg = c.accent_soft, bold = true })
    hl("ColorColumn", { bg = c.bg_warm })
    hl("SignColumn", { bg = c.bg })
    hl("Folded", { fg = c.fg_muted, bg = c.bg_warm })
    hl("StatusLine", { fg = c.fg, bg = c.surface })
    hl("StatusLineNC", { fg = c.fg_muted, bg = c.bg_dim })
    hl("TabLine", { fg = c.fg_muted, bg = c.bg_dim })
    hl("TabLineSel", { fg = c.fg, bg = c.surface, bold = true })
    hl("Pmenu", { fg = c.fg, bg = c.surface })
    hl("PmenuSel", { fg = c.fg, bg = c.accent_dim })
    hl("PmenuThumb", { bg = c.surface3 })
    hl("WildMenu", { fg = c.bg, bg = c.accent })
    hl("Directory", { fg = c.accent_soft })
    hl("Title", { fg = c.accent, bold = true })
    hl("Error", { fg = c.accent })
    hl("ErrorMsg", { fg = c.accent })
    hl("WarningMsg", { fg = c.warn })
    hl("MoreMsg", { fg = c.ok })
    hl("Question", { fg = c.accent_soft })
    hl("NonText", { fg = c.fg_muted })
    hl("SpecialKey", { fg = c.fg_muted })
    hl("Whitespace", { fg = c.surface3 })
    hl("Comment", { fg = c.fg_muted, italic = true })
    hl("Constant", { fg = c.warn })
    hl("String", { fg = c.ok })
    hl("Character", { fg = c.ok })
    hl("Number", { fg = c.warn })
    hl("Boolean", { fg = c.warn })
    hl("Identifier", { fg = c.fg })
    hl("Function", { fg = c.accent_soft })
    hl("Statement", { fg = c.accent })
    hl("Keyword", { fg = c.accent })
    hl("Operator", { fg = c.steel })
    hl("PreProc", { fg = c.accent_soft })
    hl("Type", { fg = c.steel })
    hl("Special", { fg = c.accent_soft })
    hl("Underlined", { underline = true })
    hl("Todo", { fg = c.warn, bold = true })

    hl("DiagnosticError", { fg = c.accent })
    hl("DiagnosticWarn", { fg = c.warn })
    hl("DiagnosticInfo", { fg = c.steel })
    hl("DiagnosticHint", { fg = c.fg_dim })
    hl("DiagnosticUnderlineError", { undercurl = true, sp = c.accent })
    hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.warn })

    hl("DiffAdd", { bg = "#1a2418" })
    hl("DiffChange", { bg = c.accent_subtle })
    hl("DiffDelete", { bg = "#2a1418", fg = c.accent })
    hl("DiffText", { bg = c.accent_dim })

    hl("GitSignsAdd", { fg = c.ok })
    hl("GitSignsChange", { fg = c.warn })
    hl("GitSignsDelete", { fg = c.accent })

    hl("@keyword", { fg = c.accent })
    hl("@function", { fg = c.accent_soft })
    hl("@string", { fg = c.ok })
    hl("@comment", { fg = c.fg_muted, italic = true })
    hl("@type", { fg = c.steel })
    hl("@variable", { fg = c.fg })
    hl("@constant", { fg = c.warn })
    hl("@property", { fg = c.steel })
end

return M
