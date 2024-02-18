return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      local configs = require 'nvim-treesitter.configs'

      configs.setup({
        ensure_installed = { "go", "vim" },
        sync_install = false,
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        },
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
      })
    end
  },
  {
    "Wansmer/treesj",
    config = function()
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
    end
  }
}
