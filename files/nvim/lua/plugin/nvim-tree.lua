return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup {
      view = {
        -- grows with the longest visible line, within limits
        width = { min = 30, max = "40%", padding = 1 },
      },
      renderer = {
        root_folder_label = false,
        icons = {
          show = {
            git = false,
            modified = false,
          },
        },
        -- removes higlight of readme.md/Makefile
        special_files = {},
      },
      filters = {
        dotfiles = true, -- hidden by default, H toggles
        custom = {
          '.*_templ.go',
          '.*_templ.txt',
          'go.sum',
        }
      }
    }

    -- let LSP update imports when files are renamed in the tree
    local events = require("nvim-tree.api").events
    events.subscribe(events.Event.NodeRenamed, function(data)
      Snacks.rename.on_rename_file(data.old_name, data.new_name)
    end)

    -- opening the tree from a project file also reveals that file in it
    vim.keymap.set('n', '<leader><leader>', function()
      local file = vim.bo.buftype == "" and vim.uv.fs_realpath(vim.api.nvim_buf_get_name(0))
      local cwd = vim.uv.cwd() -- nil when cwd was deleted
      local root = cwd and vim.uv.fs_realpath(cwd)
      require("nvim-tree.api").tree.toggle({
        find_file = file and root and vim.startswith(file, root .. "/") or false,
        focus = true,
      })
    end, { desc = "File tree" })
    vim.keymap.set('n', '<leader>a', ':NvimTreeFindFile<CR>', { desc = "Reveal file in tree" })
  end
}
