return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'saghen/blink.cmp',
    'b0o/schemastore.nvim',
  },

  config = function()
    -- built-in gr* mappings (0.11+) would make `gr` wait for timeoutlen
    for _, lhs in ipairs({ 'grn', 'gra', 'grr', 'gri', 'grt', 'grx' }) do
      pcall(vim.keymap.del, 'n', lhs)
    end
    pcall(vim.keymap.del, 'x', 'gra')

    vim.diagnostic.config({
      virtual_text = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '\u{f057} ',
          [vim.diagnostic.severity.WARN] = '\u{f071} ',
          [vim.diagnostic.severity.HINT] = '\u{f0eb} ',
          [vim.diagnostic.severity.INFO] = '\u{f05a} ',
        },
      },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
      callback = function(args)
        local bufmap = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = args.buf })
        end

        bufmap('n', 'K', vim.lsp.buf.hover)
        bufmap('n', 'gd', vim.lsp.buf.definition)
        bufmap('n', 'gy', '<cmd>Trouble lsp_type_definitions focus=true<cr>')
        bufmap('n', 'gi', '<cmd>Trouble lsp_implementations focus=true<cr>')
        bufmap('n', '<leader>s', '<cmd>Trouble symbols<cr>')
        bufmap('n', 'gfr', '<cmd>Trouble lsp_references focus=true<cr>')
        bufmap('n', 'gr', vim.lsp.buf.rename)
        bufmap({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action)
      end,
    })

    vim.lsp.config('*', {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
    })

    vim.lsp.config('gopls', {
      settings = {
        gopls = {
          templateExtensions = { 'html', 'tmpl', 'gotmpl' },
        },
      },
    })

    vim.lsp.config('jsonls', {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config('yamlls', {
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
    })

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
          telemetry = { enable = false },
        },
      },
    })

    vim.lsp.config('emmet_language_server', {
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
        'gotmpl',
      },
    })

    vim.lsp.enable({
      'templ',
      'gopls',
      'tsc', -- native TypeScript 7 language server
      'jsonls',
      'yamlls',
      'lua_ls',
      'emmet_language_server',
      'marksman',
    })
  end
}
