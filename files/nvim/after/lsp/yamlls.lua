---@type vim.lsp.Config
return {
  settings = {
    yaml = {
      keyOrdering = false,
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = vim.tbl_extend('force', require('schemastore').yaml.schemas({
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
      }), {
        -- kubernetes is not in schemastore: bundled in yamlls as the `kubernetes` keyword, off
        -- by default. The docs are the same kubectl explain reads (K = hover, field completion,
        -- validation). The kubectl edit temp file matches its own glob, so `kedit` gets the
        -- schema wherever it runs; add work repo globs here when needed
        kubernetes = { '**/k8stest/**/*.yaml', '**/kubectl-edit-*.yaml' },
      }),
      -- gitlab ci `!reference [job, script]`
      customTags = { '!reference sequence' },
    },
  },
}
