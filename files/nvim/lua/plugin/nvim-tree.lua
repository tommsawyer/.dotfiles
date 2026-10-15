return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup {
      renderer = {
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
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

    vim.keymap.set('n', '<leader><leader>', '<Cmd>NvimTreeToggle<CR>', { desc = "File tree" })
    vim.keymap.set('n', '<leader>a', ':NvimTreeFindFile<CR>', { desc = "Reveal file in tree" })
  end
}
