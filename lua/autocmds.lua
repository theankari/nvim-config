local autocmd = vim.api.nvim_create_autocmd

autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Quick buffer switching
for i = 1, 9, 1 do
  vim.keymap.set("n", string.format("<A-%s>", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufs[i])
  end)
end

vim.cmd("syntax off")

autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
    vim.bo[ev.buf].tabstop = 2
    vim.bo[ev.buf].shiftwidth = 2
  end,
  pattern = { "terraform", "hcl" },
})
