-- generated and noisy files, hidden from the file and grep pickers
local exclude = { ".git/", "node_modules", "*_templ.go", "*_templ.txt", "go.sum" }

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = {
      enabled = true,
      layout = {
        preset = "select",
      },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    bigfile = { enabled = true },
    gitbrowse = { enabled = true },
    zen = {
      enabled = true,
      toggles = {
        dim = false, -- don't highlight only the current paragraph
        git_signs = false,
        mini_diff_signs = false,
      },
    },
    styles = {
      zen = {
        -- solid background around zen window instead of dimmed editor
        backdrop = { transparent = false, blend = 99 },
        -- plain text: no line numbers, sign column (git signs, diagnostics) and dropbar winbar
        wo = {
          winbar = "",
          number = false,
          relativenumber = false,
          signcolumn = "no",
          foldcolumn = "0",
        },
      },
    },
    rename = { enabled = true },
    -- indent scopes as i= a= text objects ([= ]= are in mappings.lua);
    -- the default [i ]i ii ai are conditionals from treesitter-textobjects here
    scope = {
      enabled = true,
      treesitter = { enabled = false }, -- by indentation only (treesitter scopes are odd in yaml)
      keys = {
        textobject = {
          ii = false,
          ai = false,
          ["i="] = { min_size = 2, edge = false, cursor = false, desc = "inner scope" },
          ["a="] = { min_size = 2, cursor = false, desc = "full scope" },
        },
        jump = {
          ["[i"] = false,
          ["]i"] = false,
        },
      },
    },
  },

  keys = {
    { "<leader>go", function() Snacks.gitbrowse() end,                    desc = "Open in browser", mode = { "n", "v" } },
    { "<leader>n",  function() Snacks.notifier.show_history() end,        desc = "Notification history" },
    { "<leader>z",  function() Snacks.zen() end,                          desc = "Zen mode" },

    { "<space>",    function() Snacks.picker.files({ exclude = exclude }) end, desc = "Files" },
    { "<leader>f",  function() Snacks.picker.grep({ exclude = exclude }) end,  desc = "Live Grep" },
    { "<leader>d",  function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP workspace symbols" },
    { "<leader>h",  function() Snacks.picker.help() end,                  desc = "Help tags" },
    { "<leader>b",  function() Snacks.picker.buffers() end,               desc = "Buffers" },
  },
}
