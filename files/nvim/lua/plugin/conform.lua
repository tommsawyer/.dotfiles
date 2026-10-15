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
        -- like Xcode: no reformatting unless the project has its own .swift-format,
        -- and never through sourcekit-lsp (same swift-format with 2-space defaults)
        swift = { "swift_format", lsp_format = "never" },
        python = { "ruff_organize_imports", "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },

      formatters = {
        swift_format = {
          condition = function(_, ctx)
            return vim.fs.find(".swift-format", { path = ctx.dirname, upward = true })[1] ~= nil
          end,
        },
      },

      -- kotlin and ruby have no formatter here: fall back to their LSP
      -- (kotlin-lsp with IntelliJ style, ruby-lsp with the project's rubocop)
      -- defaults that formatters_by_ft entries can override (swift: lsp_format = "never")
      default_format_opts = {
        lsp_format = "fallback",
      },

      format_on_save = {
        timeout_ms = 500,
      },
    })
  end
}
