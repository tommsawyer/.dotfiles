require("nvim-tree").setup {
  view = {
    hide_root_folder = true,
  },
  renderer = {
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
