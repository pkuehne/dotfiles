-- Use the system Qt's qmlls. Mason's build links against libodbc.so.2 and
-- fails to start without unixODBC installed.
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      qmlls = {
        mason = false,
        cmd = { "/usr/lib/qt6/bin/qmlls" },
      },
    },
  },
}
