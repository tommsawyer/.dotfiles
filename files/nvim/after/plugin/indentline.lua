local indentline = require("ibl")

indentline.setup {
  indent = {
    char = "│",
  },
  exclude = {
    filetypes = { "help", "packer", "NvimTree", },
    buftypes = { "terminal", "nofile" },
  },
  scope = {
    enabled = true,
  },
}
