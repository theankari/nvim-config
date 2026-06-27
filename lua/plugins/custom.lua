local plugins = {
  -- Override plugin definition options

  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension "lazygit"
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "leoluz/nvim-dap-go",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP continue / start" },
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "DAP step into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "DAP toggle REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP toggle UI" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "DAP terminate" },
      { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "DAP debug Go test" },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      dapui.setup()
      require("nvim-dap-virtual-text").setup()
      require("dap-go").setup()

      -- JS/TS (node) via js-debug-adapter installed by Mason.
      local mason = vim.fn.stdpath "data" .. "/mason"
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { mason .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }
      for _, ft in ipairs { "javascript", "typescript", "javascriptreact", "typescriptreact" } do
        dap.configurations[ft] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- Auto open/close the UI with the debug session.
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
}

return plugins
