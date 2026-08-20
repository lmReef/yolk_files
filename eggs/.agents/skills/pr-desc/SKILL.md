---
name: pr-desc
description: Updates the authenticated user's GitHub pull request description with the gh CLI, using their three most recent PRs in the repository as a style guide and optional Jira issue context. Use when asked to write, refresh, or update an existing PR body.
---

# PR Description

Update an existing PR body from its actual changes. Use prior PRs only to match the author's style; never copy their facts.

## Inputs

Accept an optional PR number or URL and an optional Jira issue key such as `ABC-123`. If no PR is supplied, list the most recent PRs authored by @me and ask which to use.

## Jira Context

1. If the user supplied an issue key, use it.
2. Otherwise run `git rev-parse --abbrev-ref HEAD` and look for a Jira key matching a project key followed by a number, such as `ABC-123`.
3. Use the branch key only when exactly one unambiguous match exists. Normalize it to uppercase.
4. If no key or multiple plausible keys are found, ask whether to continue without Jira context or which key to use. Do not guess.
5. Fetch the selected issue with `jira issue view ISSUE-KEY --plain`. Use its summary, description, and acceptance criteria as context. If Jira lookup fails, report the failure and ask whether to continue without it.

Do not copy unrelated Jira details, comments, private operational data, or acceptance criteria the PR does not satisfy. Never claim the issue is complete merely because it is linked.

## Workflow

1. Verify the repository, target PR, and authentication with `gh` before drafting.
2. Get the authenticated login with `gh api user --jq .login` and the target PR's `author.login` with `gh pr view`. Compare them case-insensitively. If they differ or ownership cannot be verified, stop without changing the PR.
3. Read repository instructions and any PR template. Preserve mandatory template sections.
4. Inspect the target PR's title, existing body, base/head branches, commits, changed files, and diff using `gh pr view` and `gh pr diff`.
5. List the authenticated author's PRs in the current repository, newest first, excluding the target PR. Use the three most recent available PRs across all states.
6. Infer only recurring presentation choices from those PRs:
   - heading names and order
   - summary length and tone
   - bullets versus prose
   - testing or checklist format
   - placement of issue references
7. Draft a body describing only the target PR. Preserve accurate, useful content from its existing body and include relevant Jira context when available.
8. Verify every statement against the diff, commits, existing checks, or Jira issue. Do not state that tests passed unless there is evidence.
9. Save the exact current and proposed bodies to separate temporary files. Avoid shell interpolation of body content.
10. Show a labeled side-by-side preview, with current body on the left and proposed body on the right, using `diff --side-by-side --width="${COLUMNS:-160}" CURRENT PROPOSED || true`.
11. Ask for explicit approval. If revisions are requested, update the proposed file and show a new side-by-side diff. If there is no difference, make no update.
12. Only after approval, update the description with `gh pr edit PR --body-file PROPOSED`.
13. Read the PR body back with `gh pr view` and verify the update, then remove the temporary files.

## Boundaries

- Do not change the PR title, labels, reviewers, assignees, milestone, base branch, or draft state.
- Never update a PR not authored by the authenticated user.
- Never copy issue numbers, links, implementation details, test results, or claims from prior PRs.
- Use fewer than three prior PRs when fewer exist; if none exist, follow the repository template and current body.
- Do not discard meaningful manually written content without incorporating or explicitly preserving it.
- Stop and ask if the target PR is ambiguous. Never update a guessed PR.
- Never run `gh pr edit` until the side-by-side diff has been shown and the user explicitly approves it.
- Never merge, close, or approve the PR.

## Result

Report the updated PR URL, Jira issue used or `none`, prior PRs used as style references, and any facts or sections that could not be verified.
