return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.5',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        sorting_strategy = "ascending",
        layout_strategy = "center",
        path_display = { "absolute" },
        preview = false,
        results_title = false,
        prompt_title = false,
        file_ignore_patterns = { ".git/", "node_modules", ".*_templ.go", "go.sum" },
      },
    }

    vim.keymap.set('n', ' ', builtin.find_files, {})
    vim.keymap.set('n', '<leader>f', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>d', builtin.lsp_dynamic_workspace_symbols, {})
    vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>b', builtin.buffers, {})
  end
}
