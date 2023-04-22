require('gitsigns').setup({
  on_attach = function()
    vim.keymap.set("n", "<leader>gu", ":Gitsigns reset_hunk<CR>")
  end
})
