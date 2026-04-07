vim.g.mapleader = " "

vim.keymap.set("n", "<C-c>", "<C-a>", { noremap = true, silent = true })

-- move selected blocks and indent
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")

-- nav and keep cursor in a good spot
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- yank to system clipboard
vim.keymap.set("n", "y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("v", "y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y')

-- delete no hist
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete no history" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete no history" })

vim.keymap.set("n", "<C-_>", [[:/\<<C-r><C-w>\><cr>]], { desc = "Jump to next instance of word" })
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Custom replace word" }
)
vim.keymap.set("n", "<leader>x", ":silent !chmod +x %<cr>", { desc = "chmod +x" })

vim.keymap.set("n", "<leader>ww", ":w<cr>", { desc = ":w" })
vim.keymap.set("n", "<leader>ws", ":noa w<cr>", { desc = ":noa w" })
vim.keymap.set("n", "<leader>wq", ":wq<cr>", { desc = ":wq" })
vim.keymap.set("n", "<leader>q", ":q!<cr>", { desc = ":q!" })

-- open links
-- vim.keymap.set("n", "<cr>", function()
-- 	local word = vim.fn.expand("<cWORD>")
-- 	if string.find(word, "http") then
-- 		vim.cmd("silent !" .. os.getenv("BROWSER") .. " " .. word)
-- 	end
-- end)
