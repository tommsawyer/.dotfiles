-- menu and the entry component under the cursor in the drop-down menu
local function menu_component()
  local menu = require("dropbar.utils").menu.get_current()
  if not menu then return end
  local cursor = vim.api.nvim_win_get_cursor(menu.win)
  return menu, menu.entries[cursor[1]]:first_clickable(cursor[2])
end

-- path of the file or folder under the cursor in the menu, nil for symbols (functions etc.)
local function menu_path()
  local _, component = menu_component()
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
      -- a thin › with a space on both sides instead of the nerd font chevron with one after it
      icons = { ui = { bar = { separator = " › " } } },
      bar = {
        -- the default needs a treesitter parser or LSP; show at least the path for any file
        -- (tmux.conf, gitconfig...), keeping the default exclusions
        enable = function(buf, win)
          if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win)
              or vim.fn.win_gettype(win) ~= "" or vim.wo[win].winbar ~= "" or vim.bo[buf].ft == "help" then
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
        -- in data files the key path is the structure: take it from treesitter (the LSP
        -- symbols below are code-only), elsewhere the default (path + LSP or treesitter)
        sources = function(buf)
          local sources = require("dropbar.sources")
          local ft = vim.bo[buf].ft
          if ft == "yaml" or ft == "json" or ft == "jsonc" or ft == "toml" then
            return { sources.path, sources.treesitter }
          end
          if ft == "markdown" then return { sources.path, sources.markdown } end
          if vim.bo[buf].bt == "terminal" then return { sources.terminal } end
          return {
            sources.path,
            require("dropbar.utils").source.fallback({ sources.lsp, sources.treesitter }),
          }
        end,
      },
      -- code structure only: no table fields, values, ifs and returns in the breadcrumbs
      sources = {
        -- preview files, not folders: a folder is a raw `ls -lhA`, its sub-menu (o) looks better
        path = {
          preview = function(path) return vim.fn.isdirectory(path) == 0 end,
        },
        lsp = {
          valid_symbols = {
            "File", "Module", "Namespace", "Package", "Class", "Struct", "Interface", "Enum",
            "Constructor", "Method", "Function",
          },
        },
        treesitter = {
          valid_types = {
            "namespace", "package", "class", "struct", "interface", "enum",
            "constructor", "method", "function",
            "pair", "block_mapping_pair", "table", -- keys in json / yaml / toml
          },
        },
      },
      menu = {
        win_configs = { border = "none" }, -- just the background, like the completion menu
        keymaps = {
          -- like o in nvim-tree (and <CR> here): folder -> its sub-menu, file -> open it
          ["o"] = function()
            local menu, component = menu_component()
            if menu and component then
              menu:click_on(component, nil, 1, "l")
            end
          end,
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
              -- absolute or ~ paths are taken as is
              local file = name:match("^[/~]") and vim.fs.normalize(name) or vim.fs.joinpath(dir, name)
              vim.fn.mkdir(vim.fs.dirname(file), "p")
              vim.cmd.edit(vim.fn.fnameescape(file))
            end)
          end,
        },
      },
    })

    -- pick labels look like flash labels; the icon under the cursor in the menu on the same band
    -- as its entry (colorscheme.lua), not reversed: dropbar sets that itself, so the theme
    -- cannot undo it. Again after a colorscheme reload clears it
    local function link_pick_hl()
      -- flash defines FlashLabel only on its first jump; same default, so flash keeps it as is
      vim.api.nvim_set_hl(0, "FlashLabel", { link = "Substitute", default = true })
      vim.api.nvim_set_hl(0, "DropBarIconUIPickPivot", { link = "FlashLabel" })
      vim.api.nvim_set_hl(0, "DropBarMenuHoverIcon", { link = "DropBarMenuHoverEntry" })
    end
    link_pick_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = link_pick_hl,
      group = vim.api.nvim_create_augroup("DropBarPickHl", { clear = true }),
    })

    -- folder and file names in the menu coloured as in nvim-tree (colorscheme.lua), the bar keeps
    -- its own; later: the menu buffer gets its filetype before dropbar opens the window and sets
    -- its winhighlight
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dropbar_menu",
      callback = function(args)
        vim.schedule(function()
          for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
            vim.wo[win].winhighlight = vim.wo[win].winhighlight
                .. ",DropBarKindDir:DropBarMenuKindDir,DropBarKindFile:DropBarMenuKindFile"
          end
        end)
      end,
      group = vim.api.nvim_create_augroup("DropBarMenuNames", { clear = true }),
    })

    -- dropbar dims the icons of a window it leaves (winhighlight Xxx:XxxNC) and undims on enter;
    -- winhighlight is kept per buffer in a window, so a file opened from the menu leaves the
    -- previous buffer saved dimmed, and <C-o> back to it brings icons on the inactive background
    vim.api.nvim_create_autocmd("BufWinEnter", {
      callback = function()
        -- later: a buffer put into another window (from the menu) is entered while focus stays put
        local win = vim.api.nvim_get_current_win()
        vim.schedule(function()
          if win ~= vim.api.nvim_get_current_win() then return end
          local kept = vim.tbl_filter(function(pair)
            return not pair:match("^DropBar.*:DropBar.*NC$")
          end, vim.split(vim.wo.winhighlight, ",", { trimempty = true }))
          vim.opt_local.winhighlight = table.concat(kept, ",")
        end)
      end,
      group = vim.api.nvim_create_augroup("DropBarUndimShown", { clear = true }),
    })

    vim.keymap.set("n", "<leader>;", require("dropbar.api").pick, { desc = "Pick in breadcrumbs" })
  end,
}
