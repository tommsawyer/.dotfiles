return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      -- / and ? stay plain search, jumps go through Enter
      search = {
        enabled = false,
      },
    },
  },
  keys = {
    -- plain jump on Enter, except special buffers (quickfix, terminal...) where Enter does its own thing
    {
      "<CR>",
      function() return vim.bo.buftype == "" and "<cmd>lua require('flash').jump()<cr>" or "<CR>" end,
      mode = "n",
      expr = true,
      desc = "Flash",
    },
    { "r", mode = "o",          function() require("flash").remote() end,     desc = "Remote Flash" },
    { "S", mode = { "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
