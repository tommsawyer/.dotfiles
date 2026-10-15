-- path of the file under the cursor in the drop-down menu, nil for symbols (functions etc.)
local function menu_path()
  local menu = require("dropbar.utils").menu.get_current()
  if not menu then return end
  local cursor = vim.api.nvim_win_get_cursor(menu.win)
  local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
  return component and component.data and component.data.path
end

local function close_menus()
  require("dropbar.utils").menu.exec("close")
end

-- breadcrumbs in winbar: path and the symbols around the cursor
return {
  "Bekaboo/dropbar.nvim",
  config = function()
    require("dropbar").setup({
      bar = {
        -- the default needs a treesitter parser or LSP; show at least the path for any file
        -- (tmux.conf, gitconfig...), keeping the default exclusions
        enable = function(buf, win)
          if vim.fn.win_gettype(win) ~= "" or vim.wo[win].winbar ~= "" or vim.bo[buf].ft == "help" then
            return false
          end
          local name = vim.api.nvim_buf_get_name(buf)
          local stat = vim.uv.fs_stat(name)
          if stat and stat.size > 1024 * 1024 then
            return false
          end
          return vim.bo[buf].bt == "terminal" or (vim.bo[buf].bt == "" and name ~= "")
        end,
        -- same labels as flash, in the same order
        pick = { pivots = "asdfghjklqwertyuiopzxcvbnm" },
      },
      menu = {
        keymaps = {
          -- reveal the file or folder in nvim-tree
          ["t"] = function()
            local path = menu_path()
            if not path then return end
            close_menus()
            require("nvim-tree.api").tree.find_file({ buf = path, open = true, focus = true })
          end,
          -- new file in the folder under the cursor (or next to the file under the cursor)
          ["a"] = function()
            local path = menu_path()
            if not path then return end
            local dir = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
            close_menus()
            vim.ui.input({ prompt = "New file in " .. vim.fn.fnamemodify(dir, ":~:.") .. "/" }, function(name)
              if not name or name == "" then return end
              local file = vim.fs.joinpath(dir, name)
              vim.fn.mkdir(vim.fs.dirname(file), "p")
              vim.cmd.edit(vim.fn.fnameescape(file))
            end)
          end,
        },
      },
    })

    -- pick labels look like flash labels; again after a colorscheme reload clears it
    local function link_pick_hl()
      -- flash defines FlashLabel only on its first jump; same default, so flash keeps it as is
      vim.api.nvim_set_hl(0, "FlashLabel", { link = "Substitute", default = true })
      vim.api.nvim_set_hl(0, "DropBarIconUIPickPivot", { link = "FlashLabel" })
    end
    link_pick_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = link_pick_hl,
      group = vim.api.nvim_create_augroup("DropBarPickHl", { clear = true }),
    })

    vim.keymap.set("n", "<leader>;", require("dropbar.api").pick, { desc = "Pick in breadcrumbs" })
  end,
}
