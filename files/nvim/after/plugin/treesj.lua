local tsj = require('treesj')

tsj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 120,
  cursor_behavior = 'hold',
  notify = true,
  dot_repeat = true,
})

vim.keymap.set('n', 'gJ', tsj.join)
vim.keymap.set('n', 'gS', tsj.split)
