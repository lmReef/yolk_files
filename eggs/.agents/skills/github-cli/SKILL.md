---
name: github-cli
description: Uses the authenticated GitHub CLI to query PRs and issues, compare or cross-reference PRs across repositories, and safely update the authenticated user's own PRs. Use for any request involving GitHub, GitHub URLs, or gh commands, especially PR/issue lookups, cross-repository research, and PR changes.
compatibility: Requires gh authenticated to the GitHub host containing the requested resources.
---

# GitHub CLI

Use `gh` for GitHub operations. Prefer read-only commands and the narrowest command that satisfies the request.

## Start

1. Run `gh auth status` and identify the target host.
2. Get the authenticated login with `gh api user --jq .login` (add `--hostname HOST` when needed).
3. Resolve every target to an unambiguous PR, issue, repository, or URL. Ask rather than guess.
4. For operations outside the current repository, always pass `--repo OWNER/REPO` or use the full API path. Do not rely on the current Git remote.

## Read Operations

- Use `gh pr view/list/diff/checks`, `gh issue view/list`, and `gh search prs/issues` before raw API calls.
- Request structured fields with `--json` and filter with `--jq` when practical.
- Use `gh api --paginate` when the answer requires a complete multi-page result.
- Treat PR and issue numbers as repository-local. Report repository-qualified references and URLs.
- Distinguish verified facts from inferred relationships.

For cross-repository PR comparisons, fetch each PR independently with its explicit repository. Compare only the data needed for the request, such as title/body, author, state, base/head branches, commits, changed files, checks, and linked issues. Do not infer that PRs are related from matching numbers or similar titles alone; verify with links, commits, branches, or content.

## PR Writes

Before **any** PR property update:

1. Fetch the PR's current `author.login`, URL, and relevant current properties with `gh pr view`.
2. Compare `author.login` to the authenticated login case-insensitively.
3. If they differ or ownership cannot be verified, stop. Other people's PRs are read-only.
4. Show the exact proposed change and obtain explicit approval unless the user's current message already specifies that exact change.
5. Use the narrowest `gh pr edit` command and then read the changed fields back to verify them.

PR properties include the title, body, base branch, labels, assignees, reviewers, milestone, draft/ready state, and open/closed state. Never change any of these on another person's PR, even if requested.

For PR description work, load and follow the `pr-desc` skill when available. Its preview and approval requirements still apply, and this ownership check takes precedence.

## Absolute Prohibitions

- **Never merge a PR.** Do not run `gh pr merge`, enable auto-merge, call merge API endpoints, or execute GraphQL mutations that merge or schedule a merge, even if requested.
- Never update properties of a PR whose author is not the authenticated user.
- Never bypass either prohibition with `gh api`, aliases, scripts, extensions, git pushes, or another tool.
- Do not expose authentication tokens or credential-bearing output.

## Result

Report the repository-qualified resources inspected, concise findings with URLs, any mutation made and verified, and anything blocked by the ownership or merge rules.
