return {
	-- https://github.com/folke/snacks.nvim
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = {},
		indent = {
			animate = { enabled = false },
		},
		-- scope = {},
		-- rename = {},
		-- keymap = {},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
}
