return {
	"tpope/vim-rhubarb",

	{ "akinsho/git-conflict.nvim", version = "*", config = true },

	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", ":tab Git<cr>))", { desc = "Git status" })
			vim.keymap.set("n", "<leader>gb", ":Git blame<cr>", { desc = "Git blame" })
			vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<cr>", { desc = "Git diff side-by-side" })
			vim.keymap.set("n", "<leader>gc", ":Git commit<cr>", { desc = "Git commit" })
			vim.keymap.set("n", "<leader>gp", ":Git push<cr>", { desc = "Git push" })
			vim.keymap.set("n", "<leader>go", ":Git pull<cr>", { desc = "Git pull" })
			vim.keymap.set("n", "<leader>gg", ":GBrowse<cr>", { desc = "Open file in github" })
			vim.keymap.set("n", "<leader>ga", ":Git add %<cr>", { desc = "Git add" })
			vim.keymap.set("n", "<leader>gl", ":!gh auth switch<cr>", { desc = "Switch Github accounts" })
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = true,
			on_attach = function(bufnr)
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]czz", bang = true })
					else
						gitsigns.nav_hunk("next")
						vim.cmd.normal({ "zz", bang = true })
					end
				end)

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[czz", bang = true })
					else
						gitsigns.nav_hunk("prev")
						vim.cmd.normal({ "zz", bang = true })
					end
				end)
			end,
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
				delay = 300,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		},
	},
}
