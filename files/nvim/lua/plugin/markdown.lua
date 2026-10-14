return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    latex = { enabled = false },
    html = { comment = { conceal = false } }, -- show <!-- comments --> as is
  },
}
