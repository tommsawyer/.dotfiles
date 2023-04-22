require("nvim-tree").setup {
  renderer = {
    root_folder_label = false,
    icons = {
      show = {
        git = false,
        modified = false,
      },
    },
  },
}

vim.keymap.set('n', '<leader><leader>', '<Cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>a', ':NvimTreeFindFile<CR>')
