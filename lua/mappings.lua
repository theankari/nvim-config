require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<A-t>", function()
  require("base46").toggle_theme()
end, { desc = "Toggle light/dark theme" })

map("n", "<leader>tt", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle transparency" })

map("n", "<leader>gi", ":LazyGit<CR>", { desc = "Open LazyGit" })

map("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "LSP toggle inlay hints" })

-- map("n", "<A-j>", function()
--   require("nvchad.tabufline").prev()
-- end, { desc = "Move to prev buffer" })

-- map("n", "<A-k>", function()
--   require("nvchad.tabufline").next()
-- end, { desc = "Move to next buffer" })

-- pane switching
map("n", "<C-h>", ":TmuxNavigateLeft<CR>")
map("n", "<C-j>", ":TmuxNavigateDown<CR>")
map("n", "<C-k>", ":TmuxNavigateUp<CR>")
map("n", "<C-l>", ":TmuxNavigateRight<CR>")

-- kubectl mappings
map("n", "<leader>k", function()
    require("kubectl").toggle()
end, { desc = "Toggle kubectl" })
