return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'saghen/blink.cmp', -- loaded first: it adds its completion capabilities to vim.lsp.config('*')
    'b0o/schemastore.nvim',
  },

  config = function()
    vim.diagnostic.config({
      -- message only on the cursor line, the rest just has signs and underlines
      virtual_text = { current_line = true },
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
        local buf = args.buf
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buf = buf, desc = 'Hover' })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buf = buf, desc = 'Go to definition' })
        vim.keymap.set('n', 'gy', '<cmd>Trouble lsp_type_definitions focus=true<cr>',
          { buf = buf, desc = 'Type definitions (Trouble)' })
        vim.keymap.set('n', 'gi', '<cmd>Trouble lsp_implementations focus=true<cr>',
          { buf = buf, desc = 'Implementations (Trouble)' })
        vim.keymap.set('n', '<leader>s', '<cmd>Trouble symbols<cr>', { buf = buf, desc = 'Symbols (Trouble)' })
        -- built-in gr*/gO defaults open quickfix; send the lists to Trouble too
        vim.keymap.set('n', 'grr', '<cmd>Trouble lsp_references focus=true<cr>',
          { buf = buf, desc = 'References (Trouble)' })
        vim.keymap.set('n', 'gri', '<cmd>Trouble lsp_implementations focus=true<cr>',
          { buf = buf, desc = 'Implementations (Trouble)' })
        vim.keymap.set('n', 'grt', '<cmd>Trouble lsp_type_definitions focus=true<cr>',
          { buf = buf, desc = 'Type definitions (Trouble)' })
        vim.keymap.set('n', 'gO', '<cmd>Trouble symbols<cr>', { buf = buf, desc = 'Symbols (Trouble)' })
        vim.keymap.set({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, { buf = buf, desc = 'Code action' })
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
                url =
                'https://gitlab.com/gitlab-org/gitlab-foss/-/raw/master/app/assets/javascripts/editor/schema/ci.json',
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
          disableOrganizeImports = true,                -- ruff does it
          analysis = { typeCheckingMode = 'standard' }, -- default "recommended" is very noisy
        },
      },
    })

    -- ruff: lint + format + imports; hover comes from basedpyright
    vim.lsp.config('ruff', {
      on_attach = function(client) client.server_capabilities.hoverProvider = false end,
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
        },
      },
    })

    -- the default filetypes plus go templates
    vim.lsp.config('emmet_language_server', {
      filetypes = vim.list_extend(vim.deepcopy(vim.lsp.config.emmet_language_server.filetypes), { 'templ', 'gotmpl' }),
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
