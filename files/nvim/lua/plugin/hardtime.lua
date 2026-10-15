-- habit trainer: blocks spamming hjkl and friends, hints at a better motion
return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    -- merged with the defaults (NvimTree, qf, help, lazy... are already there)
    disabled_filetypes = { ["dropbar_menu*"] = true }, -- breadcrumbs drop-down and its fuzzy finder
  },
}
