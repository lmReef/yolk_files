---
name: docs-sync
description: Synchronizes existing documentation and examples with code, API, CLI, configuration, and behavior changes. Use after implementation changes, when reviewing documentation impact, or when asked to update stale README, guides, reference docs, or examples.
---

# Docs Sync

Keep existing documentation accurate for the change at hand. Keep wording and tone consistent. Make the smallest complete documentation update; do not rewrite unrelated prose.

## Scope

Use the scope supplied by the user. Otherwise, in a Git repository, inspect staged and unstaged changes against `HEAD`, including untracked files. If there is no change or named target, ask what should be synchronized instead of guessing.

## Workflow

1. Read repository instructions and documentation policies (`AGENTS.md`, `CONTRIBUTING.md`, and local equivalents).
2. Inspect the complete target diff before editing documentation.
3. Identify user-visible effects, especially changes to:
   - public APIs, types, and behavior
   - CLI commands, flags, defaults, and output
   - configuration, environment variables, and file formats
   - installation, deployment, migration, and troubleshooting steps
   - examples and supported versions
4. Search existing documentation for affected names, old behavior, and related examples. Check `README*`, `docs/`, examples, templates, and user-facing help where present.
5. Update only affected sources. Preserve their structure, terminology, voice, and detail level.
6. Verify commands, snippets, links, defaults, and claims against the implementation. Never invent behavior to fill a gap.
7. Run existing repository-native documentation checks or generators when available. Do not add tooling solely for this task.
8. Review the final diff for stale references, accidental generated-file edits, and unrelated cleanup.

## Boundaries

- Do not manually edit generated documentation; update its source and run the existing generator.
- Do not update changelogs or release notes unless requested or required by repository policy.
- Do not change implementation merely to make it match the docs. Report unclear or conflicting intended behavior.
- Do not create a documentation framework, dependency, or broad new document unless the change cannot be documented accurately in existing locations.
- Do not run destructive, production, deployment, or credential-bearing example commands just to validate them.
- If no documentation change is needed, make no edit and explain which user-visible surfaces were checked.

## Result

Report:

- documentation files changed and why
- checks or generators run
- unresolved gaps, ambiguities, or generated docs that could not be refreshed
