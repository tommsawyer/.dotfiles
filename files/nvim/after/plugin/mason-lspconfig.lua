require("mason").setup()
require("mason-lspconfig").setup()

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
end

local lspconfig = require('lspconfig')

require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
    })
  end,
})


lspconfig.yamlls.setup {
  settings = {
    yaml = {
      keyOrdering = false,
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}

lspconfig.lua_ls.setup({
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
