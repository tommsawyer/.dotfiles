return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup({
      on_attach = function()
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']g', function()
          if vim.wo.diff then return ']g' end
          vim.schedule(function() gs.nav_hunk("next", { navigation_message = false }) end)
          return '<Ignore>'
        end, { expr = true, desc = "Next git hunk" })

        map('n', '[g', function()
          if vim.wo.diff then return '[g' end
          vim.schedule(function() gs.nav_hunk("prev", { navigation_message = false }) end)
          return '<Ignore>'
        end, { expr = true, desc = "Previous git hunk" })

        vim.keymap.set("n", "<leader>gu", ":Gitsigns reset_hunk<CR>", { silent = true, desc = "Reset hunk" })
        vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>", { silent = true, desc = "Blame line" })
        vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { silent = true, desc = "Preview hunk" })
      end
    })
  end
}
