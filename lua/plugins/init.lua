return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "terraform-ls",
        "lua-language-server",
        "stylua",
        "css-lsp",
        "gopls",
        "html-lsp",
        "typescript-language-server",
        "prettier",
        "tflint",
        "helm-ls",
        "yaml-language-server",
        "json-lsp",
        "ansible-language-server",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "yaml",
        "json",
        "markdown",
        "markdown_inline",
        "terraform",
        "go",
      },
    },
  },
}
