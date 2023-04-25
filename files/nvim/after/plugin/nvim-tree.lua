require("nvim-tree").setup {
  renderer = {
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    root_folder_label = false,
    icons = {
      show = {
        git = false,
        modified = false,
      },
    },
    -- removes higlight of readme.md/Makefile
    special_files = {},
  },
}

vim.keymap.set('n', '<leader><leader>', '<Cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>a', ':NvimTreeFindFile<CR>')
