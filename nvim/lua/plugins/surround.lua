require("mini.surround").setup({
    -- Default mappings:
    -- sa  - Add surrounding (works in visual mode and with motions)
    -- sd  - Delete surrounding
    -- sr  - Replace surrounding
    -- sf  - Find surrounding (to the right)
    -- sF  - Find surrounding (to the left)
    -- sh  - Highlight surrounding

    -- Builtin surroundings:
    -- t   - HTML/JSX tag (prompts for tag name)
    -- f   - function call
    -- ()  - parentheses (with/without space)
    -- []  - brackets
    -- {}  - braces
    -- <>  - angle brackets
    -- "   - double quotes
    -- '   - single quotes
    -- `   - backticks

    -- Example usage for React/HTML:
    -- Visual select text, then: sat<div> -> wraps in <div>...</div>
    -- sdt -> delete surrounding tag
    -- srt -> replace surrounding tag (prompts for new tag)
})
