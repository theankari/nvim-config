local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    tsx = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    go = { "gofumpt", "goimports-reviser" },
    sh = { "shfmt" },
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },
    tfvars = { "terraform_fmt" },
    python = { "ruff_organize_imports", "ruff_format" },
    ["terraform-vars"] = { "terraform_fmt" },
    yaml = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    markdown = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

require("conform").setup(options)
