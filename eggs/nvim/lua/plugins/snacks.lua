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
		terminal = {},
		styles = {},
		scratch = { ft = "md" },
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		-- terminal
		{
			"<leader>t",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle terminal",
		},
		-- scratch buffer
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>>",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
	},
}
