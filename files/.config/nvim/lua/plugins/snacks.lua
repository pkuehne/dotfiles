return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = { hidden = true, exclude = { ".git" } },
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
