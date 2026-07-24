return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")
		conform.setup({
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 1000,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				rust = { "rustfmt" },
				gdscript = { "gdformat" },
				sh = { "shfmt", "shellharden" },
				zsh = { "beautysh", "shellharden" },

				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				-- svelte = { "svelte" },
				html = { "prettierd" },
				css = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
			},
			["*"] = { "trim_whitespace" },
			["_"] = {},
		})

		-- vim.api.nvim_create_autocmd({ "ModeChanged" }, {
		-- 	-- pattern = {'*.c', '*.h'},
		-- 	callback = function(ev)
		-- 		if ev.new_mode == "NORMAL" then
		-- 			conform.format()
		-- 		end
		-- 	end,
		-- })
	end,
}
