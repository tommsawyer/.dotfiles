require 'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ac"] = "@call.outer",
        ["ic"] = "@call.inner",
        ["as"] = "@statement.outer",
        ["is"] = "@statement.outer",
      },
      include_surrounding_whitespace = false,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]i"] = "@conditional.outer",
        ["]l"] = "@loop.outer",
        ["]c"] = "@call.outer",
        ["]s"] = "@statement.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[i"] = "@conditional.outer",
        ["[l"] = "@loop.outer",
        ["[c"] = "@call.outer",
        ["[s"] = "@statement.outer",
      },
    },
  },

  textsubjects = {
    enable = true,
    prev_selection = ',', -- (Optional) keymap to select the previous selection
    keymaps = {
      ['.'] = 'textsubjects-smart',
      [';'] = 'textsubjects-container-outer',
      ['i;'] = 'textsubjects-container-inner',
    },
  },
}
