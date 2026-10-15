return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        go = { "gofumpt" },
        json = { "prettier" },
        templ = { "templ" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        swift = { "swift_format" },
        python = { "ruff_organize_imports", "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },

      -- kotlin and ruby have no formatter here: fall back to their LSP
      -- (kotlin-lsp with IntelliJ style, ruby-lsp with the project's rubocop)
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end
}
