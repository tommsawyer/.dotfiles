return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>t", "<cmd>Trouble diagnostics toggle focus=true<cr>", silent = true, desc = "Diagnostics (Trouble)" },
  },
  opts = {
    use_diagnostic_signs = true,
    modes = {
      -- document symbols (gO, <leader>s): wide enough to show long names in full
      -- (opened rarely, so the room is fine)
      symbols = {
        win = { size = 50 },
      },
    },
  },
}
