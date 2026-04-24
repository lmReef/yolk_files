return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		-- https://github.com/folke/snacks.nvim
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = {},
			terminal = {},
			styles = {},
			scratch = { ft = "md" },
			indent = {
				animate = { enabled = false },
			},
			picker = {
				layout = "bottom",
			},
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
				desc = "Toggle scratch buffer",
			},
			{
				"<leader>>",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select scratch buffer",
			},

			-- picker
			{
				"<leader>pg",
				function()
					Snacks.picker.pick("git_status")
				end,
				desc = "git status",
			},
			{
				"<leader>pb",
				function()
					Snacks.picker.pick("git_branches")
				end,
				desc = "git branches",
			},
			{
				"<leader>pv",
				function()
					Snacks.picker.pick("git_stash")
				end,
				desc = "git stash",
			},
			{
				"<leader>pc",
				function()
					Snacks.picker.pick("git_log")
				end,
				desc = "git log",
			},
			{
				"<leader>pk",
				function()
					Snacks.picker.pick("keymaps")
				end,
				desc = "keymaps",
			},
			{
				"<leader>ph",
				function()
					Snacks.picker.pick("help")
				end,
				desc = "help",
			},
			{
				"<leader>pr",
				function()
					Snacks.picker.pick("smart")
				end,
				desc = "smart files",
			},
			{
				"<leader>pd",
				function()
					Snacks.picker.diagnostics_buffer()
				end,
				desc = "buffer diagnostics",
			},
			{
				"<leader>pp",
				function()
					Snacks.picker.projects()
				end,
				desc = "projects",
			},
			{
				"<leader>pl",
				function()
					Snacks.picker.lines()
				end,
				desc = "fuzzy search lines",
			},
			{
				"<leader>pz",
				function()
					Snacks.picker.zoxide()
				end,
				desc = "zoxide",
			},
			{
				"<leader>pm",
				function()
					Snacks.picker.man()
				end,
				desc = "man pages",
			},
			{
				"<leader>p.",
				function()
					Snacks.picker.pickers({ layout = "select" })
				end,
				desc = "all pickers",
			},
			{
				"<leader>pt",
				function()
					Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
				end,
				desc = "Todo/Fix/Fixme",
			},
			{
				"<leader>pa",
				function()
					Snacks.picker.files({ cwd = "~/.config/yolk", hidden = true })
				end,
				desc = "dotfiles",
			},
		},
	},
}
