return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
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
