local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    sorting_strategy = "ascending",
    layout_strategy = "center",
    path_display = { "smart" },
    preview = false,
    results_title = false,
    prompt_title = false,
    file_ignore_patterns = { ".git/", "node_modules" },
  },
}

vim.keymap.set('n', ' ', builtin.git_files, {})
vim.keymap.set('n', '<leader>f', builtin.live_grep, {})
vim.keymap.set('n', '<leader>d', builtin.lsp_dynamic_workspace_symbols, {})
