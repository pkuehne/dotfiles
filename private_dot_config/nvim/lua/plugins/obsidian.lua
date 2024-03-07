return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      workspaces = {
        {
          name = "work",
          path = "~/Obsidian/Work/",
        },
      },
      templates = {
        subdir = "Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      daily_notes = {
        folder = "Journal",
        date_format = "%Y/%m/%Y-%m-%d-%A",
        template = "Daily Template.md"
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      picker = {
        name = "telescope.nvim",
      },
      preferred_link_style = "markdown",
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "New Note" },
      { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
      { "<leader>od", "<cmd>ObsidianToday<cr>",       desc = "Today's Daily Note" },
      { "<leader>ow", "<cmd>ObsidianTomorrow<cr>",    desc = "Tomorrow's Note" },
      { "<leader>oy", "<cmd>ObsidianYesterday<cr>",   desc = "Yesterday's Note" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>",    desc = "Insert Template" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>",      desc = "Search Notes" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>",       desc = "Linked Notes" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>",   desc = "Backlinks" },
      { "<leader>or", "<cmd>ObsidianRename<cr>",      desc = "Rename Note" },
      { "<leader>ol", "<cmd>ObsidianLink<cr>",        desc = "Link to Note",      mode = { 'v' } },
      { "<leader>on", "<cmd>ObsidianLinkNew<cr>",     desc = "Link to new Note",  mode = { 'v' } },
      { "<leader>oe", "<cmd>ObsidianExtract<cr>",     desc = "Extract to Note",   mode = { 'v' } },
    }
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>o"] = { name = "Obsidian" },
      },
    },
  },
}
