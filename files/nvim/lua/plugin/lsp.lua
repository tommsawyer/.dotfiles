return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'saghen/blink.cmp',
    'b0o/schemastore.nvim',
  },

  config = function()
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
        local bufmap = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
        end

        bufmap('n', 'K', vim.lsp.buf.hover, 'Hover')
        bufmap('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
        bufmap('n', 'gy', '<cmd>Trouble lsp_type_definitions focus=true<cr>', 'Type definitions (Trouble)')
        bufmap('n', 'gi', '<cmd>Trouble lsp_implementations focus=true<cr>', 'Implementations (Trouble)')
        bufmap('n', '<leader>s', '<cmd>Trouble symbols<cr>', 'Symbols (Trouble)')
        bufmap({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, 'Code action')
      end,
    })

    -- go: add missing / remove unused imports on save (gopls organizeImports),
    -- conform then formats with gofumpt
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('UserGoImports', { clear = true }),
      pattern = '*.go',
      callback = function(args)
        local client = vim.lsp.get_clients({ bufnr = args.buf, name = 'gopls' })[1]
        if not client then
          return
        end

        local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
        params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
        local result = client:request_sync('textDocument/codeAction', params, 1000, args.buf)
        for _, action in ipairs(result and result.result or {}) do
          if not action.edit then
            local resolved = client:request_sync('codeAction/resolve', action, 1000, args.buf)
            action = resolved and resolved.result or action
          end
          if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
          end
        end
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
          schemas = require('schemastore').yaml.schemas({
            extra = {
              -- same url as the catalog entry, so it replaces it: keep the catalog globs and add included files
              {
                name = 'gitlab-ci',
                description = 'GitLab CI: main file and files included from .gitlab/ci/',
                url = 'https://gitlab.com/gitlab-org/gitlab-foss/-/raw/master/app/assets/javascripts/editor/schema/ci.json',
                fileMatch = {
                  '**/.gitlab-ci.yml', '**/.gitlab-ci.yaml', '**/*.gitlab-ci.yml', '**/*.gitlab-ci.yaml',
                  '**/.gitlab/ci/*.yml', '**/.gitlab/ci/*.yaml',
                },
              },
            },
          }),
          -- gitlab ci `!reference [job, script]`
          customTags = { '!reference sequence' },
        },
      },
    })

    vim.lsp.config('basedpyright', {
      settings = {
        basedpyright = {
          disableOrganizeImports = true, -- ruff does it
          analysis = { typeCheckingMode = 'standard' }, -- default "recommended" is very noisy
        },
      },
    })

    -- ruff: lint + format + imports; hover comes from basedpyright
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserRuffNoHover', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == 'ruff' then
          client.server_capabilities.hoverProvider = false
        end
      end,
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
      'sourcekit', -- swift, comes with Xcode (kotlin is started by kotlin.nvim)
      'ruby_lsp',
      'basedpyright',
      'ruff',
      'bashls',
    })
  end
}
