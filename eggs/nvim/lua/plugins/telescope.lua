return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
					},
				},
				pickers = {
					live_grep = {
						file_ignore_patterns = { "node_modules", "%.git", "%.github", "%.venv" },
						additional_args = function(_)
							return { "--hidden" }
						end,
					},
					find_files = {
						file_ignore_patterns = {
							"node_modules",
							"seqrepo",
							"%.lock",
							"%.git",
							"%.venv",
							"%.uid",
							"%.import",
							"%.png",
							"%.jpg",
						},
						hidden = true,
					},
				},
			})
			telescope.load_extension("fzf")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>pk", builtin.keymaps, { desc = "Telescope keymaps" })
			vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>pw", builtin.grep_string, { desc = "Telescope grep word" })
			vim.keymap.set("n", "<leader>pc", builtin.git_commits, { desc = "Telescope git commits" })
			vim.keymap.set("n", "<leader>pb", builtin.git_branches, { desc = "Telescope git branches" })
			vim.keymap.set("n", "<leader>pg", builtin.git_status, { desc = "Telescope git status" })
			vim.keymap.set("n", "<leader>pv", builtin.git_stash, { desc = "Telescope git stash" })
			vim.keymap.set("n", "<leader>pm", builtin.marks, { desc = "Telescope marks" })
			vim.keymap.set("n", "<leader>pr", ":Easypick tmux-ls<cr>", { desc = "Telescope tmux sessions" })
			vim.keymap.set("n", "<leader>pt", ":Easypick tmux-new<cr>", { desc = "Telescope new tmux session" })
			vim.keymap.set("n", "<leader>pn", function()
				vim.cmd(":Telescope notify")
			end, { desc = "Telescope notification history" })
			vim.keymap.set("n", "<leader>pp", function()
				vim.cmd(":Telescope cherrypick")
			end, { desc = "Telescope cherry-pick" })
		end,
		keys = "<leader>p",
	},

	{
		"axkirillov/easypick.nvim",
		config = function()
			local easypick = require("easypick")
			easypick.setup({
				pickers = {
					{
						name = "tmux-ls",
						command = "tmux ls | grep -o -P '^.*(?=: )'",
						action = easypick.actions.nvim_command(":silent !tmux switch-client -t"),
					},
					{
						name = "tmux-new",
						command = "fd -HL -td -d1 . "
							.. os.getenv("HOME")
							.. " "
							.. os.getenv("HOME")
							.. "/projects "
							.. os.getenv("HOME")
							.. "/.config "
							.. (os.getenv("ADDITIONAL_PROJECTS") or "")
							.. " "
							.. os.getenv("HOME")
							.. "/.local/bin",
						action = easypick.actions.nvim_command(
							":silent !" .. os.getenv("HOME") .. "/.local/bin/scripts/tmux-sessionizer.sh"
						),
					},
				},
			})
		end,
		lazy = true,
		cmd = "Easypick",
	},
}
