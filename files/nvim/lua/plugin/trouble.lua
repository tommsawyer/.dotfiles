return {
  "folke/trouble.nvim",
  config = function()
    local trouble = require("trouble")

    trouble.setup({
      use_diagnostic_signs = true,
    })

    vim.keymap.set("n", "<leader>t", "<cmd>Trouble diagnostics toggle focus=true<cr>",
      { silent = true, noremap = true }
    )
  end
}
