return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- brand-new (untracked) files are not attached by default, so no signs, no hunks;
    -- with this the whole file shows as added lines
    attach_to_untracked = true,
    -- default untracked sign is a thin dashed line (┆); use the same bold bar as added
    -- lines of tracked files (the highlight already falls back to GitSignsAdd)
    signs = {
      untracked = { text = "┃" },
    },
    -- one config for every gitsigns float (blame ,gb, hunk preview ,gp, diff
    -- help): rounded frame; the body is on the editor background already --
    -- style="minimal" (the default) leaves window Normal as the theme's Normal,
    -- and winhighlight is not accepted as an nvim_open_win key in nvim 0.12
    preview_config = {
      border = "rounded",
    },
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

      -- global=true so every attached buffer follows, silently: no command echo
      vim.keymap.set("n", "<leader>gm", function()
        gs.change_base("master", true)
      end, { buf = buf, desc = "Diff against master (global)" })
      vim.keymap.set("n", "<leader>gh", function()
        gs.change_base("HEAD", true)
      end, { buf = buf, desc = "Diff against HEAD (global)" })

      vim.keymap.set("n", "<leader>gu", gs.reset_hunk, { buf = buf, desc = "Reset hunk" })
      vim.keymap.set("n", "<leader>gb", gs.blame_line, { buf = buf, desc = "Blame line" })
      vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { buf = buf, desc = "Preview hunk" })
    end,
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)

    -- gitsigns paints popup text pieces (the blame summary line, spacers) with
    -- NormalFloat, and those extmarks fill with hl_eol, so the float band shows
    -- through inside the popup; nvim_open_win (nvim 0.12) rejects winhighlight,
    -- so set it on each popup after it opens -- the plugin marks its popup
    -- windows with the w:gitsigns_preview var (WinNew fires before it is set,
    -- hence the schedule); the group is defined in colorscheme.lua
    local group = vim.api.nvim_create_augroup("GitsignsPopupStyle", { clear = true })
    vim.api.nvim_create_autocmd("WinNew", {
      group = group,
      callback = function()
        vim.schedule(function()
          for _, winid in ipairs(vim.api.nvim_list_wins()) do
            if vim.w[winid].gitsigns_preview ~= nil and vim.w[winid].gitsigns_popup_styled == nil then
              vim.w[winid].gitsigns_popup_styled = true
              if vim.api.nvim_win_is_valid(winid) then
                vim.wo[winid].winhighlight = "NormalFloat:GitSignsPopupFloat"
              end
            end
          end
        end)
      end,
    })
  end,
}
