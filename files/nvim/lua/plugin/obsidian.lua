-- notes vault: a git repo synced through a bare repo on the NAS (the "origin" remote)
local vault = vim.fn.expand("~/Documents/teamlead")

-- commit everything, rebase on the remote, push; output goes to notifications
local function sync()
  local function git(args, next)
    vim.system(vim.list_extend({ "git", "-C", vault }, args), { text = true }, function(res)
      vim.schedule(function()
        if res.code ~= 0 then
          vim.notify(table.concat(args, " ") .. ": " .. vim.trim(res.stderr .. res.stdout), vim.log.levels.ERROR,
            { title = "Notes sync" })
        elseif next then
          next()
        else
          vim.notify("Synced", vim.log.levels.INFO, { title = "Notes sync" })
        end
      end)
    end)
  end
  local function pull_push()
    git({ "pull", "--rebase" }, function() git({ "push" }) end)
  end
  vim.cmd("silent! wall")
  git({ "add", "-A" }, function()
    -- commit exits 1 when there is nothing to commit, so check the index first
    vim.system({ "git", "-C", vault, "diff", "--cached", "--quiet" }, {}, function(res)
      vim.schedule(function()
        if res.code == 0 then
          pull_push()
        else
          git({ "commit", "-m", "notes: " .. os.date("%Y-%m-%d %H:%M") .. " " .. vim.fn.hostname() }, pull_push)
        end
      end)
    end)
  end)
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  -- only for files in the vault, not every markdown file
  event = { "BufReadPre " .. vault .. "/*.md", "BufNewFile " .. vault .. "/*.md" },
  cmd = "Obsidian",
  -- a function: obsidian.builtin is not on the runtimepath before the plugin loads
  opts = function()
    ---@type obsidian.config
    return {
      legacy_commands = false,
      workspaces = { { name = "teamlead", path = vault } },
      -- readable file names from the title instead of random ids
      note_id_func = require("obsidian.builtin").title_id,
      -- plain files, the same as in the Obsidian app
      frontmatter = { enabled = false },
      footer = { enabled = false },
      statusline = { enabled = false },
      ui = { enable = false },
      picker = { name = "snacks.pick" },
      daily_notes = { folder = "daily" },
      templates = {
        folder = "templates",
        -- a note made from templates/<name>.md goes into the folder next to it
        customizations = {
          ["1-1"] = { notes_subdir = "1-1" },
          week = { notes_subdir = "weeks" },
        },
      },
    }
  end,
  keys = {
    { "<leader>oo", "<cmd>Obsidian quick_switch<cr>",      desc = "Notes" },
    { "<leader>of", "<cmd>Obsidian search<cr>",            desc = "Search notes" },
    { "<leader>on", "<cmd>Obsidian new_from_template<cr>", desc = "New note from template" },
    { "<leader>ot", "<cmd>Obsidian today<cr>",             desc = "Today's note" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>",         desc = "Backlinks" },
    { "<leader>os", sync,                                  desc = "Sync notes" },
  },
}
