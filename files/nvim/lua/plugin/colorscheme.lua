return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    theme = "wave",
    background = { dark = "wave" },
    colors = {
      theme = {
        -- sign/number column without its own darker background
        all = { ui = { bg_gutter = "none" } },
      },
    },
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd("colorscheme kanagawa-wave")
  end
}
