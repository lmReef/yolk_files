return {
	-- https://github.com/nvim-mini/mini.nvim
	"echasnovski/mini.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		require("mini.bracketed").setup({})
		require("mini.surround").setup({})
		require("mini.cursorword").setup({})
		require("mini.align").setup({})
		require("mini.pairs").setup({})

		local miniclue = require("mini.clue")
		miniclue.setup({
			triggers = {
				-- Leader triggers
				{ mode = "n", keys = "<Leader>" },
				{ mode = "x", keys = "<Leader>" },

				-- Built-in completion
				{ mode = "i", keys = "<C-x>" },

				-- `g` key
				{ mode = "n", keys = "g" },
				{ mode = "x", keys = "g" },

				-- Marks
				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "x", keys = "'" },
				{ mode = "x", keys = "`" },

				-- Registers
				{ mode = "n", keys = '"' },
				{ mode = "x", keys = '"' },
				{ mode = "i", keys = "<C-r>" },
				{ mode = "c", keys = "<C-r>" },

				-- Window commands
				{ mode = "n", keys = "<C-w>" },

				-- `z` key
				{ mode = "n", keys = "z" },
				{ mode = "x", keys = "z" },
			},
			clues = {
				-- Enhance this by adding descriptions for <Leader> mapping groups
				miniclue.gen_clues.builtin_completion(),
				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers(),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),
			},
		})

		require("mini.comment").setup({
			options = {
				ignore_blank_line = true,
			},
			mappings = {
				comment_line = "<leader>c",
				comment_visual = "<leader>c",
			},
		})
	end,
}
