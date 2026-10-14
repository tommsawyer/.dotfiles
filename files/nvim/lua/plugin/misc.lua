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
      vim.keymap.set("n", "sa", "<Plug>(nvim-surround-normal)")
      vim.keymap.set("n", "sd", "<Plug>(nvim-surround-delete)")
      vim.keymap.set("n", "sr", "<Plug>(nvim-surround-change)")
      vim.keymap.set("x", "sa", "<Plug>(nvim-surround-visual)")
    end,
  },
  { "nvim-tree/nvim-web-devicons" }, -- better icons
  { "Bekaboo/dropbar.nvim" },        -- breadcrumbs in winbar
  {
    -- native `gc` commenting picks up commentstring from treesitter context
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = { enable_autocmd = false },
  },
}
