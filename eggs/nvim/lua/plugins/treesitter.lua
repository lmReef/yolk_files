return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"query",
				"gdscript",
				"python",
				"bash",
				"fish",
				"json",
				"yaml",
				"toml",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		})
		vim.treesitter.language.register("groovy", "nextflow")
		vim.api.nvim_create_autocmd({ "FileType" }, { pattern = "dockerfile", command = "TSBufDisable highlight" })
	end,
}
