local parsers = {
  "bash",
  "css",
  "dockerfile",
  "embedded_template",
  "git_config",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "gowork",
  "groovy",
  "html",
  "javascript",
  "kotlin",
  "json",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "nginx",
  "python",
  "query",
  "ruby",
  "sql",
  "swift",
  "templ",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zsh",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            -- only where nvim-treesitter has indent queries (not kotlin, templ, ...),
            -- otherwise indentexpr returns 0 and new lines start at column 0
            local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
            if lang and vim.treesitter.query.get(lang, "indents") then
              vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end
        end,
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true, -- whether to set jumps in the jumplist
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local selects = {
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
      }
      for lhs, query in pairs(selects) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end, { desc = query:gsub("^@", ""):gsub("%.", " ") })
      end

      local move = require("nvim-treesitter-textobjects.move")
      local moves = {
        f = "@function.outer",
        i = "@conditional.outer",
        l = "@loop.outer",
        c = "@call.outer",
        s = "@statement.outer",
      }
      for key, query in pairs(moves) do
        vim.keymap.set({ "n", "x", "o" }, "]" .. key, function()
          move.goto_next_start(query, "textobjects")
        end, { desc = "Next " .. query:match("@(%w+)") })
        vim.keymap.set({ "n", "x", "o" }, "[" .. key, function()
          move.goto_previous_start(query, "textobjects")
        end, { desc = "Previous " .. query:match("@(%w+)") })
      end
    end
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "templ", "gotmpl", "eruby", "javascriptreact", "typescriptreact", "vue", "svelte" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
      aliases = {
        templ = "html",
      },
    },
  },
  {
    "Wansmer/treesj",
    keys = {
      { "gJ", function() require("treesj").join() end,  desc = "Join block" },
      { "gS", function() require("treesj").split() end, desc = "Split block" },
    },
    opts = {
      use_default_keymaps = false,
      check_syntax_error = true,
      max_join_length = 120,
      cursor_behavior = 'hold',
      notify = true,
      dot_repeat = true,
    },
  }
}
