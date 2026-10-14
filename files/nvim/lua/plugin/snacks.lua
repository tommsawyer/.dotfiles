return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = {
      enabled = true,
      layout = {
        preset = "select",
      },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    bigfile = { enabled = true },
    gitbrowse = { enabled = true },
    rename = { enabled = true },
    indent = {
      enabled = true,
      indent = { char = "▏" },
      scope = { char = "▏" },
      animate = { enabled = false },
    },
    lazygit = { enabled = true },
  },

  keys = {
    { "<leader>gl", function() Snacks.lazygit() end,                      desc = "Lazygit" },
    { "<leader>go", function() Snacks.gitbrowse() end,                    desc = "Open in browser", mode = { "n", "v" } },
    { "<leader>n",  function() Snacks.notifier.show_history() end,        desc = "Notification history" },

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
