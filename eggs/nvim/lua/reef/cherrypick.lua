local utils = require("telescope.utils")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local previewers = require("telescope.previewers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local strings = require("plenary.strings")

local get_git_command_output = function(args, opts)
	return utils.get_os_command_output(utils.__git_command(args, opts), opts.cwd)
end

local cherrypick = function(opts)
	opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))
	opts.git_command = vim.F.if_nil(
		opts.git_command,
		utils.__git_command({ "log", opts.branch_selection, "--pretty=oneline", "--abbrev-commit", "--", "." }, opts)
	)

	pickers
		.new(opts, {
			prompt_title = "Select commit to pick",
			finder = finders.new_oneshot_job(opts.git_command, opts),
			previewer = {
				previewers.git_commit_diff_to_parent.new(opts),
				previewers.git_commit_diff_to_head.new(opts),
				previewers.git_commit_diff_as_was.new(opts),
				previewers.git_commit_message.new(opts),
			},
			sorter = conf.file_sorter(opts),
			attach_mappings = function()
				actions.select_default:replace(function(bufnr)
					actions.close(bufnr)
					vim.cmd("Git cherry-pick " .. action_state.get_selected_entry().value)
				end)
				return true
			end,
		})
		:find()
end

local branches = function(opts)
	opts = opts or {}

	local format = "%(HEAD)"
		.. "%(refname)"
		.. "%(authorname)"
		.. "%(upstream:lstrip=2)"
		.. "%(committerdate:format-local:%Y/%m/%d %H:%M:%S)"

	local output = get_git_command_output(
		{ "for-each-ref", "--perl", "--format", format, "--sort", "-authordate", opts.pattern },
		opts
	)

	local show_remote_tracking_branches = vim.F.if_nil(opts.show_remote_tracking_branches, true)

	local results = {}
	local widths = {
		name = 0,
		authorname = 0,
		upstream = 0,
		committerdate = 0,
	}
	local unescape_single_quote = function(v)
		return string.gsub(v, "\\([\\'])", "%1")
	end
	local parse_line = function(line)
		local fields = vim.split(string.sub(line, 2, -2), "''")
		local entry = {
			head = fields[1],
			refname = unescape_single_quote(fields[2]),
			authorname = unescape_single_quote(fields[3]),
			upstream = unescape_single_quote(fields[4]),
			committerdate = fields[5],
		}
		local prefix
		if vim.startswith(entry.refname, "refs/remotes/") then
			if show_remote_tracking_branches then
				prefix = "refs/remotes/"
			else
				return
			end
		elseif vim.startswith(entry.refname, "refs/heads/") then
			prefix = "refs/heads/"
		else
			return
		end
		local index = 1
		if entry.head ~= "*" then
			index = #results + 1
		end

		entry.name = string.sub(entry.refname, string.len(prefix) + 1)
		for key, value in pairs(widths) do
			widths[key] = math.max(value, strings.strdisplaywidth(entry[key] or ""))
		end
		if string.len(entry.upstream) > 0 then
			widths.upstream_indicator = 2
		end
		table.insert(results, index, entry)
	end
	for _, line in ipairs(output) do
		parse_line(line)
	end
	if #results == 0 then
		return
	end

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 1 },
			{ width = widths.name },
			{ width = widths.authorname },
			{ width = widths.upstream_indicator },
			{ width = widths.upstream },
			{ width = widths.committerdate },
		},
	})

	local make_display = function(entry)
		return displayer({
			{ entry.head },
			{ entry.name, "TelescopeResultsIdentifier" },
			{ entry.authorname },
			{ string.len(entry.upstream) > 0 and "=>" or "" },
			{ entry.upstream, "TelescopeResultsIdentifier" },
			{ entry.committerdate },
		})
	end

	pickers
		.new(opts, {
			prompt_title = "Select a branch to pick from",
			finder = finders.new_table({
				results = results,
				entry_maker = function(entry)
					entry.value = entry.name
					entry.ordinal = entry.name
					entry.display = make_display
					return make_entry.set_default_entry_mt(entry, opts)
				end,
			}),
			previewer = previewers.git_branch_log.new(opts),
			sorter = conf.file_sorter(opts),
			attach_mappings = function()
				actions.select_default:replace(function(bufnr)
					opts.branch_selection = action_state.get_selected_entry().value
					actions.close(bufnr)
					cherrypick(opts)
				end)
				return true
			end,
		})
		:find()
end

return branches
