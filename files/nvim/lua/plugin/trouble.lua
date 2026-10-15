return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>t", "<cmd>Trouble diagnostics toggle focus=true<cr>", silent = true, desc = "Diagnostics (Trouble)" },
  },
  opts = {
    use_diagnostic_signs = true,
  },
}
