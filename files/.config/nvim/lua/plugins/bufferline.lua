-- Only the active tab is filled; every other tab is dim text on nothing, so the
-- row reads like the tmux bar above it (discrete marks, transparent gaps)
-- instead of one solid slab butted against it. Slanted and blocky separators
-- were tried and looked heavy next to the rounded tmux badges.
local sel = "#3b4261" -- fg_gutter, active tab (matches the tmux window badge)
local text = "#c8d3f5"
local dim = "#636da6" -- comment
local orange = "#ff966c"
local red = "#ff757f"

return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      separator_style = "thin",
      indicator = { style = "icon" },
      always_show_bufferline = true,
    },
    highlights = {
      fill = { bg = "NONE" },

      background = { fg = dim, bg = "NONE" },
      buffer_visible = { fg = text, bg = "NONE" },
      buffer_selected = { fg = text, bg = sel, bold = true, italic = false },

      separator = { fg = dim, bg = "NONE" },
      separator_visible = { fg = dim, bg = "NONE" },
      separator_selected = { fg = dim, bg = "NONE" },

      indicator_selected = { bg = sel },
      indicator_visible = { fg = dim, bg = "NONE" },

      modified = { fg = orange, bg = "NONE" },
      modified_visible = { fg = orange, bg = "NONE" },
      modified_selected = { fg = orange, bg = sel },

      close_button = { fg = dim, bg = "NONE" },
      close_button_visible = { fg = dim, bg = "NONE" },
      close_button_selected = { fg = red, bg = sel },

      duplicate = { fg = dim, bg = "NONE", italic = true },
      duplicate_visible = { fg = dim, bg = "NONE", italic = true },
      duplicate_selected = { fg = text, bg = sel, italic = true },

      offset_separator = { fg = dim, bg = "NONE" },
    },
  },
}
