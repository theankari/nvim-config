-- This file  needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "onedark",
  transparency = false,
  theme_toggle = {"onedark", "one_light"},
  statusline = {
      theme = "default",
      separator_style = "arrow",
  },

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
	},
}

return M
