return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  cmd = { "ToggleTerm" },
  version = "*",
  keys = {
    {
      "<leader>td",
      function()
        require("toggleterm").toggle(1, 15, vim.loop.cwd(), "horizontal")
      end,
      desc = "Open Terminal",
    },
  },
}
