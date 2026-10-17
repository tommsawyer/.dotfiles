return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- keys only in buffers gitsigns is attached to (files in a git repo)
    on_attach = function(buf)
      local gs = require("gitsigns")

      vim.keymap.set("n", "]g", function()
        if vim.wo.diff then return "]c" end -- built-in next diff change (noremap: not the treesitter ]c)
        vim.schedule(function() gs.nav_hunk("next", { navigation_message = false }) end)
        return "<Ignore>"
      end, { buf = buf, expr = true, desc = "Next git hunk" })
      vim.keymap.set("n", "[g", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.nav_hunk("prev", { navigation_message = false }) end)
        return "<Ignore>"
      end, { buf = buf, expr = true, desc = "Previous git hunk" })

      vim.keymap.set("n", "<leader>gu", gs.reset_hunk, { buf = buf, desc = "Reset hunk" })
      vim.keymap.set("n", "<leader>gb", gs.blame_line, { buf = buf, desc = "Blame line" })
      vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { buf = buf, desc = "Preview hunk" })
    end,
  },
}
