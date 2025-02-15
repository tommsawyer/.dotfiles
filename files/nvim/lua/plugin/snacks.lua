return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- bigfile = { enabled = true },
    -- dashboard = { enabled = true },
    -- explorer = { enabled = true },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    picker = {
      enabled = true,
      layout = {
        preset = "select",
      },
    },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- scope = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
    lazygit = { enabled = true },
  },

  keys = {
    { "<leader>gl", function() Snacks.lazygit() end,                      desc = "Lazygit" },

    {
      "<space>",
      function()
        Snacks.picker.files({
          exclude = {
            ".git/",
            "node_modules",
            "*_templ.go",
            "*_templ.txt",
            "go.sum",
          },
        })
      end,
      desc = "Files"
    },
    {
      "<leader>f",
      function()
        Snacks.picker.grep({
          exclude = {
            ".git/",
            "*node_modules*",
            "*_templ.go",
            "*_templ.txt",
            "go.sum",
          },
        })
      end,
      desc = "Live Grep"
    },
    { "<leader>d",  function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Definitions" },
    { "<leader>h",  function() Snacks.picker.help() end,                  desc = "Help tags" },
    { "<leader>b",  function() Snacks.picker.buffers() end,               desc = "Buffers" },
  },
}
