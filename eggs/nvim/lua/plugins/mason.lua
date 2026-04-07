return {
	{
		"williamboman/mason.nvim",
		opts = {},
		dependencies = {
			"luarocks/luarocks",
		},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			handlers = {
				function(server_name)
					vim.lsp.config[server_name].setup({
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
					})
				end,
			},
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				-- vim
				"vim-language-server",
				"vint",
				-- lua
				"stylua",
				"selene",
				"lua-language-server",
				-- bash/zsh/fish
				"bash-language-server",
				"shfmt",
				"beautysh",
				"shellcheck",
				"shellharden",
				"fish_lsp",
				-- python
				"ty",
				"ruff",
				-- js
				"typescript-language-server",
				"svelte-language-server",
				"biome", -- for lsp, not formatter
				-- "prettierd",
				-- docker
				"dockerfile-language-server",
				-- c
				"clangd",
				"cpplint",
				"clang-format",
				-- other
				"gdtoolkit",
				"rustfmt",
				"hyprls",
				"ts_query_ls", -- treesitter query files
				"write-good",
			},
		},
	},
}
