-- setup lsp_zero
-- local lsp_zero = require("lsp-zero")

-- lsp_zero.on_attach(function(client, bufnr)
-- 	local opts = { buffer = bufnr, noremap = true }

-- 	vim.keymap.set("n", "gd", function()
-- 		vim.lsp.buf.definition()
-- 	end, opts)
-- 	vim.keymap.set("n", "K", function()
-- 		vim.lsp.buf.hover({ border = "rounded" })
-- 	end, opts)
-- 	vim.keymap.set("n", "<C-j>", function()
-- 		vim.diagnostic.goto_next()
-- 	end, opts)
-- 	vim.keymap.set("n", "<C-k>", function()
-- 		vim.diagnostic.goto_prev()
-- 	end, opts)
-- 	vim.keymap.set("n", "<leader>l", function()
-- 		vim.lsp.buf.references()
-- 	end, opts)
-- 	vim.keymap.set("n", "<leader>r", function()
-- 		vim.lsp.buf.rename()
-- 	end, opts)
-- end)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers["textDocument/hover"], {
	border = "rounded",
})
