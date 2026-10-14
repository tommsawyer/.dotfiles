return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}
  },
  { "machakann/vim-sandwich" },
  { "tpope/vim-unimpaired" },
  { "nvim-tree/nvim-web-devicons" }, -- better icons
  { "Bekaboo/dropbar.nvim" },        -- breadcrumbs in winbar
  {
    -- native `gc` commenting picks up commentstring from treesitter context
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = { enable_autocmd = false },
  },
}
