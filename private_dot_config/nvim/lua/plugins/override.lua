-- Overrides for LazyVim auto-loaded plugins
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "markdownlint",
      },
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        -- ["<leader>t"] = { name = "ToggleTerm" },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "tabs",
        always_show_bufferline = false,
      },
    },
  },
}
