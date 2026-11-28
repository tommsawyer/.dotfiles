return {
  "rgroli/other.nvim",
  cmd = "Other",
  keys = {
    { "<leader>T", "<cmd>Other<cr>", desc = "Go: test/source file" },
  },
  config = function()
    require("other-nvim").setup({ mappings = { "golang" }, showMissingFiles = false })
  end,
}
