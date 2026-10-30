-- Tokyo Night Moon, from folke/tokyonight.nvim extras/lua/tokyonight_moon.lua

local M = {
    bg_dark1     = "191b29",
    bg_dark      = "1e2030",
    bg           = "222436",
    bg_highlight = "2f334d",
    fg_gutter    = "3b4261",
    dark3        = "545c7e",
    comment      = "636da6",
    dark5        = "737aa2",
    fg_dark      = "828bb8",
    fg           = "c8d3f5",

    blue         = "82aaff",
    blue1        = "65bcff",
    cyan         = "86e1fc",
    teal         = "4fd6be",
    green        = "c3e88d",
    yellow       = "ffc777",
    orange       = "ff966c",
    red          = "ff757f",
    magenta      = "c099ff",
    purple       = "fca7ea",
}

function M.rgb(name)
    return "rgb(" .. M[name] .. ")"
end

function M.rgba(name, alpha)
    return "rgba(" .. M[name] .. alpha .. ")"
end

return M
