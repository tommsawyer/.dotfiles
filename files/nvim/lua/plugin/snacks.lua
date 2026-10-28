-- generated and noisy files, hidden from the file and grep pickers
local exclude = { ".git/", "node_modules", "*_templ.go", "*_templ.txt", "go.sum" }

-- the matcher lowercases with string.lower, which skips non-ASCII (Cyrillic), so lowercase
-- such paths here; byte lengths stay the same, so match highlights still line up
local function lower_text(item)
  if item.text:find("[\128-\255]") then
    item.text = vim.fn.tolower(item.text)
  end
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = {
      enabled = true,
      prompt = "❯ ",
      layout = {
        preset = "select",
        -- rounded frame over an editor dimmed with the theme's bg_d (lua/theme.lua)
        layout = { border = "rounded", backdrop = { blend = 40, bg = require("theme").bg_d } },
      },
      formatters = {
        file = { filename_first = true }, -- name first, then the dimmed path
      },
      -- always case-insensitive, even with capitals in the query
      matcher = { smartcase = false },
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
        -- a couple of empty lines above the text; shorter by as much so it does not run off the bottom
        row = 2,
        height = function(win) return win:parent_size().height - 2 end,
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
    { "<leader>go", function() Snacks.gitbrowse() end,                                                 desc = "Open in browser",      mode = { "n", "v" } },
    { "<leader>n",  function() Snacks.notifier.show_history() end,                                     desc = "Notification history" },
    { "<leader>z",  function() Snacks.zen() end,                                                       desc = "Zen mode" },

    { "<space>",    function() Snacks.picker.files({ exclude = exclude, transform = lower_text }) end, desc = "Files" },
    { "<leader>f",  function() Snacks.picker.grep({ exclude = exclude }) end,                          desc = "Live Grep" },
    { "<leader>d",  function() Snacks.picker.lsp_workspace_symbols() end,                              desc = "LSP workspace symbols" },
    { "<leader>h",  function() Snacks.picker.help() end,                                               desc = "Help tags" },
    { "<leader>b",  function() Snacks.picker.buffers() end,                                            desc = "Buffers" },
  },
}
