return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup({
      on_attach = function()
        vim.keymap.set("n", "<leader>gu", ":Gitsigns reset_hunk<CR>")
        vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>")
        vim.keymap.set("n", "]h", ":Gitsigns next_hunk<CR>")
        vim.keymap.set("n", "[h", ":Gitsigns prev_hunk<CR>")
      end
    })
  end
}
