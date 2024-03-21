return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "S", mode = { "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
