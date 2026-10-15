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
      },

      -- kotlin has no formatter here: falls back to kotlin-lsp (IntelliJ code style)
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end
}
