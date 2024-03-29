return {
  "williamboman/mason.nvim",             -- managing LSP/DAP servers
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- bridge between mason and lspconfig
    "neovim/nvim-lspconfig",             -- default lsp configs
    "b0o/schemastore.nvim",              -- schemas for yaml/json
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single",
      }
    )

    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    local lsp_attach = function(client, bufnr)
      local bufmap = function(mode, lhs, rhs)
        local opts = { buffer = true }
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
      bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
      bufmap('n', 'gy', '<cmd>TroubleToggle lsp_type_definitions<cr>')
      bufmap('n', 'gi', '<cmd>TroubleToggle lsp_implementations<cr>')
      bufmap('n', 'gfr', '<cmd>TroubleToggle lsp_references<cr>')
      bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<cr>')
      bufmap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>')
      bufmap('v', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>')
      bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
      bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

      if vim.bo.filetype == "templ" then
        if client.name == "html" then
          -- templ lsp doesn't support documentSymbolProvider yet, so use html for .templ files
          require("nvim-navic").attach(client, bufnr)
        end
      else
        if client.server_capabilities["documentSymbolProvider"] then
          require("nvim-navic").attach(client, bufnr)
        end
      end
    end

    local lspconfig = require('lspconfig')

    require('mason-lspconfig').setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({
          on_attach = lsp_attach,
          capabilities = lsp_capabilities,
        })
      end,

      ["yamlls"] = function()
        lspconfig.yamlls.setup {
          on_attach = lsp_attach,
          capabilities = lsp_capabilities,
          settings = {
            yaml = {
              keyOrdering = false,
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require('schemastore').yaml.schemas(),
            },
          },
        }
      end,

      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          on_attach = lsp_attach,
          capabilities = lsp_capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
              telemetry = {
                enable = false,
              },
            },
          },
        })
      end,

      ["emmet_language_server"] = function()
        lspconfig.emmet_language_server.setup({
          on_attach = lsp_attach,
          handlers = handlers,
          capabilities = lsp_capabilities,
          filetypes = {
            'astro',
            'css',
            'eruby',
            'html',
            'htmldjango',
            'javascriptreact',
            'less',
            'pug',
            'sass',
            'scss',
            'svelte',
            'typescriptreact',
            'vue',
            'templ',
          },
        })
      end
    })
  end
}
