return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	{
		"nextflow-io/vim-language-nextflow",
		ft = "nextflow",
	},

	{
		"goerz/jupytext.nvim",
		version = "0.2.0",
		opts = {
			jupytext = "jupytext",
			format = "auto",
			update = true,
			-- filetype = require("jupytext").get_filetype,
			-- new_template = require("jupytext").default_new_template(),
			sync_patterns = { "*.md", "*.py", "*.jl", "*.R", "*.Rmd", "*.qmd" },
			autosync = true,
			handle_url_schemes = true,
		},
	},

	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {},
	},

	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", function()
				vim.cmd.UndotreeToggle()
				vim.cmd.UndotreeFocus()
			end, { desc = "UndoTree toggle" })
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		opts = {},
		ft = {
			"astro",
			"glimmer",
			"handlebars",
			"html",
			"javascript",
			"jsx",
			"markdown",
			"php",
			"rescript",
			"svelte",
			"tsx",
			"twig",
			"typescript",
			"vue",
			"xml",
		},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		opts = {},
	},
}
