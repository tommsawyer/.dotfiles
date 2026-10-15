return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}
  },
  {
    -- sandwich-style keys: sa{motion}{char}, sd{char}, sr{old}{new}, visual sa{char}
    "kylechui/nvim-surround",
    event = "VeryLazy",
    init = function()
      vim.g.nvim_surround_no_mappings = true
    end,
    config = function()
      require("nvim-surround").setup()
      vim.keymap.set("n", "sa", "<Plug>(nvim-surround-normal)", { desc = "Surround add" })
      vim.keymap.set("n", "sd", "<Plug>(nvim-surround-delete)", { desc = "Surround delete" })
      vim.keymap.set("n", "sr", "<Plug>(nvim-surround-change)", { desc = "Surround replace" })
      vim.keymap.set("x", "sa", "<Plug>(nvim-surround-visual)", { desc = "Surround selection" })
    end,
  },
  { "nvim-tree/nvim-web-devicons" }, -- better icons
}
