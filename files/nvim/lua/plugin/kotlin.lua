-- official kotlin-lsp (JetBrains, brings its own JRE): brew install --cask kotlin-lsp
local function kotlin_lsp_dir()
  local dirs = vim.fn.glob("/opt/homebrew/Caskroom/kotlin-lsp/*/kotlin-server-*", false, true)
  table.sort(dirs)
  return dirs[#dirs]
end

return {
  "AlexandrosAlexiou/kotlin.nvim",
  ft = { "kotlin" },
  config = function()
    if not vim.env.KOTLIN_LSP_DIR then
      vim.env.KOTLIN_LSP_DIR = kotlin_lsp_dir()
    end
    require("kotlin").setup({
      inlay_hints = { enabled = true },
    })
  end,
}
