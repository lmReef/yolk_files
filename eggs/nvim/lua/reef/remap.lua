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

-- tmux
-- local function get_cmd()
-- 	local function run_cmd(c)
-- 		local cmd_prefix = 'silent !tmux send-keys -t .1 "'
-- 		local cmd_suffix = '"'
-- 		vim.cmd(cmd_prefix .. c .. cmd_suffix)
-- 	end

-- 	run_cmd("^c")
-- 	run_cmd("^l")

-- 	-- check for env var override first
-- 	local from_env = os.getenv("nvim_run")
-- 	if from_env then
-- 		run_cmd(from_env)
-- 	else
-- 		-- file based cmd handling
-- 		local ft = vim.api.nvim_get_option_value("ft", {})
-- 		local fp = vim.fn.expand("%")

-- 		if ft == "rust" then
-- 			run_cmd("cargo run --release")
-- 		elseif ft == "javascript" or ft == "typescript" then
-- 			run_cmd("pnpm run dev")
-- 		elseif ft == "nextflow" then
-- 			if string.match(fp, ".test") then
-- 				run_cmd("nf-test test " .. fp)
-- 			else
-- 				run_cmd("just dry-run")
-- 			end
-- 		elseif ft == "dockerfile" then
-- 			run_cmd("docker build . --build-arg 'DOCKER_CONTEXT=.' --network=host")
-- 		end
-- 	end

-- 	run_cmd("Enter")
-- end

-- vim.keymap.set("n", "<leader>j", get_cmd, { desc = "Run command in next pane" })
