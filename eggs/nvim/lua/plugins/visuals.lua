return {
	"nvim-lualine/lualine.nvim",
	"letieu/harpoon-lualine",

	{
		"brenoprata10/nvim-highlight-colors",
		opts = {
			---@usage 'background'|'foreground'|'virtual'
			render = "background",

			virtual_symbol = "■",
			virtual_symbol_prefix = "",
			virtual_symbol_suffix = " ",
			virtual_symbol_position = "inline",

			enable_hex = true,
			enable_short_hex = true,
			enable_rgb = true,
			enable_hsl = true,
			enable_ansi = true,
			enable_xterm256 = true,
			enable_xtermTrueColor = true,
			enable_hsl_without_function = true,
			enable_var_usage = true,
			enable_named_colors = true,
			enable_tailwind = true,

			exclude_filetypes = {},
			exclude_buftypes = {},
		},
	},

	{
		"nvim-tree/nvim-web-devicons",
		opts = {
			color_icons = true,
			default = true,
			strict = true,
		},
		lazy = true,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {},
		lazy = true,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			render = "wrapped-compact",
			stages = "fade_in_slide_out",
			fps = 90,
			timeout = 3000,
			top_down = false,
			background_colour = "TabLine",
		},
	},

	-- themes

	{
		"zaldih/themery.nvim",
		lazy = false,
		config = function()
			require("themery").setup({
				themes = {
					"pywal",
					"onedark",
					"rose-pine",
					"dracula",
					"catppuccin",
					"molokai",
					"kanagawa",
					"nightfox",
					"tokyodark",
					"tokyonight",
					"gruvbox",
					"vague",
					"0x96f",
				},
				livePreview = true,
			})
		end,
	},

	-- { "AlphaTechnolog/pywal.nvim", name = "pywal" },
	-- { "navarasu/onedark.nvim", name = "onedark" },
	-- { "rose-pine/neovim", name = "rose-pine" },
	-- { "maxmx03/dracula.nvim", name = "dracula" },
	-- { "catppuccin/nvim", name = "catppuccin" },
	-- { "tomasr/molokai", name = "molokai" },
	{ "rebelot/kanagawa.nvim", name = "kanagawa" },
	-- { "edeneast/nightfox.nvim", name = "nightfox" },
	-- { "tiagovla/tokyodark.nvim", name = "tokyodark" },
	-- { "folke/tokyonight.nvim", name = "tokyonight" },
	-- { "morhetz/gruvbox", name = "gruvbox" },
	-- { "vague2k/vague.nvim", name = "vague" },
	-- {
	-- 	"filipjanevski/0x96f.nvim",
	-- 	name = "0x96f",
	-- },
}
