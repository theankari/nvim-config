return {
  {
    "stevearc/conform.nvim",
    -- Load before write so the format_on_save autocmd is registered in time.
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require "configs.conform"
    end,
  },
  { -- This needs to be loaded before the lspserver
    "towolf/vim-helm",
    lazy = false,
    ft = "helm",
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
        -- language servers
        "terraform-ls",
        "lua-language-server",
        "css-lsp",
        "gopls",
        "html-lsp",
        "typescript-language-server",
        "helm-ls",
        "yaml-language-server",
        "json-lsp",
        "ansible-language-server",
        "jdtls",
        -- formatters
        "stylua",
        "prettier",
        -- linters
        "tflint",
        "ruff",
        "golangci-lint",
        "eslint_d",
        "yamllint",
        "hadolint",
        -- debug adapters
        "delve",
        "java-debug-adapter",
        "java-test",
        "js-debug-adapter",
        -- treesitter needs the CLI to compile parsers on the `main` branch
        "tree-sitter-cli",
      },
    },
  },
  {
    -- nvim-treesitter rewrote its plugin: the old `master` branch is frozen and
    -- errors on nvim 0.12, so we track `main` and drive highlighting through the
    -- built-in 0.12 highlighter via a FileType autocmd (the `main` branch no longer
    -- enables highlighting itself or accepts `ensure_installed`).
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "vim", "vimdoc", "lua", "luadoc", "c",
        "html", "css", "javascript", "typescript", "tsx",
        "json", "jsonc", "yaml", "toml", "markdown", "markdown_inline",
        "bash", "regex", "diff", "git_config", "gitcommit",
        "go", "gomod", "gosum", "gowork", "gotmpl",
        "java", "python",
        "terraform", "hcl", "dockerfile", "make",
      }

      -- Install any missing parsers (async, no-op for already-installed ones).
      local ok, ts = pcall(require, "nvim-treesitter")
      if ok and ts.install then
        ts.install(parsers)
      end

      -- Enable the built-in treesitter highlighter per buffer.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    lazy = false,
    config = function()
      local mc = require "multicursor-nvim"
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<up>", function()
        mc.lineAddCursor(-1)
      end)
      set({ "n", "x" }, "<down>", function()
        mc.lineAddCursor(1)
      end)
      set({ "n", "x" }, "<leader><up>", function()
        mc.lineSkipCursor(-1)
      end)
      set({ "n", "x" }, "<leader><down>", function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<A-j>", function()
        mc.matchAddCursor(1)
      end)
      set({ "n", "x" }, "<leader>s", function()
        mc.matchSkipCursor(1)
      end)
      set({ "n", "x" }, "<A-k>", function()
        mc.matchAddCursor(-1)
      end)
      set({ "n", "x" }, "<leader>S", function()
        mc.matchSkipCursor(-1)
      end)

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "ramilito/kubectl.nvim",
    config = function()
      require("kubectl").setup()
    end,
  },
  {
    -- Java LSP. jdtls needs special launch handling, so it is set up per-buffer
    -- from ftplugin/java.lua rather than through the lspconfig loop.
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble diagnostics (workspace)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble symbols" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble location list" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },
}
