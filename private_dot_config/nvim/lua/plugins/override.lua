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
    },
  },
}
