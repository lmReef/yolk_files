return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
			popup_border_style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid"
			sort_case_insensitive = true, -- used when sorting files and directories in the tree

			window = {
				position = "right",
				width = 35,

				mappings = {
					["w"] = "expand_all_nodes",
				},
			},

			filesystem = {
				hijack_netrw_behavior = "open_current",
				follow_current_file = {
					enabled = true,
				},
				scan_mode = "deep",
				group_empty_dirs = true, -- when true, empty folders will be grouped together
				use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = true,
					never_show = { ".git", ".github", "__pycache__", ".pytest_cache", ".venv" },
				},
				components = {
					harpoon_index = function(config, node, _)
						local harpoon_list = require("harpoon"):list()
						local path = node:get_id()
						local harpoon_key = vim.uv.cwd()

						for i, item in ipairs(harpoon_list.items) do
							local value = item.value
							if string.sub(item.value, 1, 1) ~= "/" then
								value = harpoon_key .. "/" .. item.value
							end

							if value == path then
								vim.print(path)
								return {
									text = string.format(" 󰀱 %d", i), -- <-- Add your favorite harpoon like arrow here
									highlight = config.highlight or "NeoTreeDirectoryIcon",
								}
							end
						end
						return {}
					end,
				},
				renderers = {
					file = {

						{ "indent" },
						{ "icon" },
						{
							"container",
							content = {
								{
									"name",
									zindex = 10,
								},
								{
									"symlink_target",
									zindex = 10,
									highlight = "NeoTreeSymbolicLinkTarget",
								},
								{ "harpoon_index", zindex = 10 },
								{ "clipboard", zindex = 10 },
								{ "bufnr", zindex = 10 },
								{ "modified", zindex = 20, align = "right" },
								{ "diagnostics", zindex = 20, align = "right" },
								{ "git_status", zindex = 10, align = "right" },
								{ "file_size", zindex = 10, align = "right" },
								{ "type", zindex = 10, align = "right" },
								{ "last_modified", zindex = 10, align = "right" },
								{ "created", zindex = 10, align = "right" },
							},
						},
					},
					directory = {
						{ "indent" },
						{ "icon" },
						{ "current_filter" },
						{
							"container",
							content = {
								{ "name", zindex = 10 },
								{
									"symlink_target",
									zindex = 10,
									highlight = "NeoTreeSymbolicLinkTarget",
								},
								{ "harpoon_index", zindex = 10 },
								{ "clipboard", zindex = 10 },
								{
									"diagnostics",
									errors_only = true,
									zindex = 20,
									align = "right",
									hide_when_expanded = true,
								},
								{ "git_status", zindex = 10, align = "right", hide_when_expanded = true },
								{ "file_size", zindex = 10, align = "right" },
								{ "type", zindex = 10, align = "right" },
								{ "last_modified", zindex = 10, align = "right" },
								{ "created", zindex = 10, align = "right" },
							},
						},
					},
				},
			},
			-- event_handlers = {
			-- 	{
			-- 		-- event = "neo_tree_buffer_leave" -- TODO: harpoon integration
			-- 		event = "file_opened",
			-- 		handler = function()
			-- 			vim.cmd(":Neotree action=show")
			-- 		end,
			-- 	},
			-- },
		})

		vim.keymap.set("n", "-", function()
			if vim.api.nvim_get_option_value("buftype", { buf = vim.fn.bufnr() }) ~= "nofile" then
				vim.cmd("Neotree close")
				vim.cmd("Neotree position=current reveal")
			end
		end)
		vim.keymap.set("n", "<leader>i", function()
			vim.cmd("Neotree toggle action=show")
		end, { desc = "Neotree toggle" })
	end,
}
