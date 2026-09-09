return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      -- tokyonight/groups/bufferline.lua replaces this group with a bare
      -- { fg = git.change }, dropping the background bufferline.lua gave it —
      -- which leaves a transparent notch at the left edge of the filled active
      -- tab. Restore just the background; the colour is tokyonight's to pick.
      on_highlights = function(hl, c)
        hl.BufferLineIndicatorSelected.bg = c.fg_gutter
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-moon",
    },
  },
}
