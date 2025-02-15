return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      search = {
        enabled = true,
      },
    },
  },
  keys = {
    { "r", mode = "o",          function() require("flash").remote() end,     desc = "Remote Flash" },
    { "S", mode = { "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
