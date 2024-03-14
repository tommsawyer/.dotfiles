return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufEnter", "BufNew" },
  opts = {
    indent = {
      char = "▏",
    },
    exclude = {
      filetypes = { "help", "packer", "NvimTree", },
      buftypes = { "terminal", "nofile" },
    },
    scope = {
      enabled = true,
      show_start = false,
    },
  }
}
