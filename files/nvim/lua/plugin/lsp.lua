return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'saghen/blink.cmp',
    'b0o/schemastore.nvim',
  },

  config = function(_, opts)
    local lspconfig = require('lspconfig')
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

    local server_configs = {
      templ = {},
      gopls = {},
      ts_ls = {},
      jsonls = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
      yamlls = {
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
      },
      lua_ls = {
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
      },
      emmet_language_server = {
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
      },
    }

    for server, config in pairs(server_configs) do
      -- passing config.capabilities to blink.cmp merges with the capabilities in your
      -- `opts[server].capabilities, if you've defined it
      config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
      config.on_attach = lsp_attach
      lspconfig[server].setup(config)
    end
  end
}
