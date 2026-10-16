return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- keys only in buffers gitsigns is attached to (files in a git repo)
    on_attach = function(buf)
      local gs = require("gitsigns")
      local function map(lhs, rhs, opts)
        vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", { buffer = buf }, opts))
      end

      map("]g", function()
        if vim.wo.diff then return "]c" end -- built-in next diff change (noremap: not the treesitter ]c)
        vim.schedule(function() gs.nav_hunk("next", { navigation_message = false }) end)
        return "<Ignore>"
      end, { expr = true, desc = "Next git hunk" })
      map("[g", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.nav_hunk("prev", { navigation_message = false }) end)
        return "<Ignore>"
      end, { expr = true, desc = "Previous git hunk" })

      map("<leader>gu", gs.reset_hunk, { desc = "Reset hunk" })
      map("<leader>gb", gs.blame_line, { desc = "Blame line" })
      map("<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
    end,
  },
}
