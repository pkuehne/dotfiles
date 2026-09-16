return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = { hidden = true, exclude = { ".git" } },
          grep = { hidden = true, exclude = { ".git" } },
          explorer = { hidden = true, exclude = { ".git" } },
        },
      },
      terminal = {
        win = {
          wo = { winbar = "" },
        },
      },
    },
  },
}
