vim.lsp.config["nextflow_ls"] = {
	cmd = {
		"java",
		"-jar",
		os.getenv("HOME") .. "/.nextflow/lsp/v25.04/v25.04.3.jar",
	},
	filetypes = { "nextflow" },
	root_markers = { ".git", "nextflow.config" },
	settings = {
		nextflow = {
			files = {
				exclude = { ".git", ".nf-test", ".nf-test-unit-test", "work" },
			},
			formatting = {
				harshilAlignment = true,
				sortDeclarations = false,
				typeChecking = true,
				extendedCompletion = true,
			},
		},
	},
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
}
vim.lsp.enable("nextflow_ls")
