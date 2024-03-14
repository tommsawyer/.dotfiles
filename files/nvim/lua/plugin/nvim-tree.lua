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
          'go.sum',
        }
      }
    }

    vim.keymap.set('n', '<leader><leader>', '<Cmd>NvimTreeToggle<CR>')
    vim.keymap.set('n', '<leader>a', ':NvimTreeFindFile<CR>')
  end
}
