return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>t", "<cmd>Trouble diagnostics toggle focus=true<cr>", silent = true, desc = "Diagnostics (Trouble)" },
  },
  opts = {
    use_diagnostic_signs = true,
    modes = {
      -- document symbols (gO, <leader>s) sit on the file tree background, like a sidebar;
      -- wide enough to show long names in full (opened rarely, so the room is fine)
      symbols = {
        win = {
          size = 50,
          wo = { winhighlight = "Normal:NvimTreeNormal,NormalNC:NvimTreeNormal,EndOfBuffer:NvimTreeNormal" },
        },
      },
    },
  },
}
