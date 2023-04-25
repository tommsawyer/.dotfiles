local trouble = require("trouble")

trouble.setup({
  use_diagnostic_signs = true,
})

vim.keymap.set("n", "<leader>t", "<cmd>TroubleToggle document_diagnostics<cr>",
  {silent = true, noremap = true}
)
