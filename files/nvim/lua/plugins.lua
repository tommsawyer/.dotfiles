vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim" -- packer can manage itself

  -- managing files
  use {
    "nvim-telescope/telescope.nvim", tag = "0.1.5",
    requires = { { "nvim-lua/plenary.nvim" } }
  }                             -- fuzzy-finder
  use "nvim-tree/nvim-tree.lua" -- project tree

  -- LSP support
  use {
    "williamboman/mason.nvim",           -- managing LSP/DAP servers
    "williamboman/mason-lspconfig.nvim", -- bridge between mason and lspconfig
    "neovim/nvim-lspconfig",             -- default lsp configs
  }

  -- snippets
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"

  -- completion engine
  use "hrsh7th/nvim-cmp"
  -- completion sources
  use {
    "hrsh7th/cmp-buffer",                 -- words from buffer
    "hrsh7th/cmp-path",                   -- filesystem paths
    "hrsh7th/cmp-nvim-lsp",               -- LSP support
    "hrsh7th/cmp-nvim-lsp-signature-help" -- function arguments
  }

  -- autoformatting
  use "stevearc/conform.nvim"

  -- appearance
  use {
    "lunarvim/darkplus.nvim",              -- main theme
    "lewis6991/gitsigns.nvim",             -- git signs
    "lukas-reineke/indent-blankline.nvim", -- indentation level lines
    "stevearc/dressing.nvim",              -- better ui
    "onsails/lspkind.nvim",                -- completion icons
    "nvim-tree/nvim-web-devicons",         -- better icons
    "antoinemadec/FixCursorHold.nvim",
    "folke/trouble.nvim",                  -- better ui for linters
  }
  use({
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("barbecue").setup()
    end,
  })

  -- improving nvim
  use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" }) -- AST
  use {
    "machakann/vim-sandwich",                                   -- surround text with brackets/tags
    "tpope/vim-unimpaired",                                     -- additional paired shortcuts
    "windwp/nvim-autopairs",                                    -- auto-add closing quotes/brackets
    "numToStr/Comment.nvim",                                    -- commenting
    "b0o/schemastore.nvim",                                     -- schemas for yaml/json
    "nvim-treesitter/nvim-treesitter-textobjects",              -- additional text objects
    "RRethy/nvim-treesitter-textsubjects",                      -- additional text objects
    "Wansmer/treesj",                                           -- spilt/join lines
  }
end)
