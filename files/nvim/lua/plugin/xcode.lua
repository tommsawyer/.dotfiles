-- swift: sourcekit-lsp comes with Xcode (configured in lsp.lua);
-- this adds build / run / test on simulators for Xcode projects and SwiftPM packages.
-- In a new project run :XcodebuildSetup once (writes buildServer.json for sourcekit-lsp).
return {
  "wojciech-kulik/xcodebuild.nvim",
  ft = { "swift" },
  cmd = { "XcodebuildSetup", "XcodebuildPicker" },
  dependencies = { "MunifTanjim/nui.nvim", "folke/snacks.nvim", "nvim-tree/nvim-tree.lua" },
  opts = {},
  keys = {
    { "<leader>xx", "<cmd>XcodebuildPicker<cr>", desc = "Xcodebuild actions" },
    { "<leader>xb", "<cmd>XcodebuildBuild<cr>", desc = "Build" },
    { "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", desc = "Build & run" },
    { "<leader>xt", "<cmd>XcodebuildTest<cr>", desc = "Test" },
    { "<leader>xT", "<cmd>XcodebuildTestClass<cr>", desc = "Test class" },
    { "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", desc = "Toggle logs" },
    { "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", desc = "Select device" },
    { "<leader>xs", "<cmd>XcodebuildSelectScheme<cr>", desc = "Select scheme" },
    { "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", desc = "Toggle coverage" },
  },
}
