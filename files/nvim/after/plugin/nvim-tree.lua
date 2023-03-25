require("nvim-tree").setup()

vim.keymap.set('n', '<leader><leader>', '<Cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>a', ':NvimTreeFindFile<CR>')
