-- Per-buffer jdtls launch. jdtls can't go through the lspconfig loop because it
-- needs a launcher jar, an OS-specific config dir, and a per-project workspace.
-- Requires a JDK 17+ on PATH to run the server (separate from your project's JDK).
local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local mason = vim.fn.stdpath "data" .. "/mason"
local jdtls_pkg = mason .. "/packages/jdtls"

local launcher = vim.fn.glob(jdtls_pkg .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher == "" then
  return -- jdtls not installed yet (run :MasonInstall jdtls)
end

local config_dir
if vim.fn.has "mac" == 1 then
  config_dir = jdtls_pkg .. "/config_mac"
elseif vim.fn.has "unix" == 1 then
  config_dir = jdtls_pkg .. "/config_linux"
else
  config_dir = jdtls_pkg .. "/config_win"
end

local root_markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath "cache" .. "/jdtls/workspace/" .. project_name

-- Debug + test extension bundles (optional; only loaded if installed).
local bundles = {}
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
    "\n"
  )
)
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", true), "\n"))

local nvlsp = require "nvchad.configs.lspconfig"

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher,
    "-configuration",
    config_dir,
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  capabilities = nvlsp.capabilities,
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    pcall(jdtls.setup_dap, { hotcodereplace = "auto" })
    if client:supports_method "textDocument/inlayHint" then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    end
  end,
  init_options = {
    bundles = bundles,
  },
  settings = {
    java = {
      inlayHints = { parameterNames = { enabled = "all" } },
      signatureHelp = { enabled = true },
    },
  },
}

jdtls.start_or_attach(config)
