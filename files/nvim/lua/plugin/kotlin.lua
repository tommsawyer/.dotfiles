-- official kotlin-lsp (JetBrains, brings its own JRE): brew install --cask kotlin-lsp;
-- the kotlin-lsp on PATH links to kotlin-server-*/kotlin-lsp.sh, kotlin.nvim wants that folder
local function kotlin_lsp_dir()
  local bin = vim.fn.exepath("kotlin-lsp")
  return bin ~= "" and vim.fs.dirname(vim.fn.resolve(bin)) or nil
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
