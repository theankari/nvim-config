local nvlsp = require "nvchad.configs.lspconfig"
local on_init = nvlsp.on_init
local capabilities = nvlsp.capabilities

local lspconfig = require "lspconfig"

-- Wrap NvChad's on_attach to also turn on inlay hints where the server supports them.
local function on_attach(client, bufnr)
  nvlsp.on_attach(client, bufnr)

  if client.supports_method and client:supports_method "textDocument/inlayHint" then
    pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
  end
end

-- Servers that work fine with defaults.
local servers = { "html", "cssls", "ts_ls", "terraformls", "jsonls", "ansiblels", "yamlls", "ruff" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- Go: richer analyses + inlay hints + staticcheck.
lspconfig.gopls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      semanticTokens = true,
      analyses = {
        unusedparams = true,
        unusedwrite = true,
        nilness = true,
        shadow = true,
        useany = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}

lspconfig.basedpyright.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
}

lspconfig.helm_ls.setup {
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = "yaml-language-server",
      },
    },
  },
}
