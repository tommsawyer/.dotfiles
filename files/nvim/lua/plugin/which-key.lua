return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    -- langmapper duplicates every mapping for the russian layout, show only the originals
    filter = function(mapping)
      return not mapping.lhs:find("[\128-\255]")
    end,
    spec = {
      { "<leader>g", group = "git" },
      { "<leader>i", group = "ai" },
      { "<leader>o", group = "notes" },
      { "gr",        group = "lsp" },
      { "<leader>x", group = "xcode" },
    },
  },
}
