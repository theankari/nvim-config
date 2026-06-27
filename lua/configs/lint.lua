local lint = require "lint"

lint.linters_by_ft = {
  go = { "golangcilint" },
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  terraform = { "tflint" },
  yaml = { "yamllint" },
  dockerfile = { "hadolint" },
}

local group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = group,
  callback = function()
    -- Only lint normal, modifiable, on-disk buffers.
    if vim.bo.buftype == "" and vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})
