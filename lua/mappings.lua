require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<A-t>", function()
    require("base46").toggle_transparency()
end, { desc = "Toggle transparecy"})

map("n", "<leader>gi", ":LazyGit<CR>", { desc = "Open LazyGit" })

map("n", "<A-j>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Move to prev buffer" })

map("n", "<A-k>", function()
  require("nvchad.tabufline").next()
end, { desc = "Move to next buffer" })
