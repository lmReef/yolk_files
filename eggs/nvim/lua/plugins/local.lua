return {
	{
		"pi-nvim",
		dir = os.getenv("HOME") .. "/projects/pi-nvim",
		dependencies = { "folke/snacks.nvim" },
		cmd = {
			"Pi",
			"PiToggle",
			"PiClose",
			"PiSend",
			"PiSubmit",
			"PiClear",
			"PiAbort",
			"PiNew",
			"PiResume",
			"PiFork",
			"PiRun",
			"PiHealth",
		},
		opts = function()
			require("pi-nvim").setup({
				prefix = "<leader>v",
				width_pct = 30,
				split_right = true,
				cmd = "pi",
				selection_threshold = { lines = 25, bytes = 4096 },
				keymaps = true,
			})
		end,
	},
}
