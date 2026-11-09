---
name: release-changelog
description: Generate or update release notes for regular releases, hotfixes, bugfixes, and patches by comparing Git version tags and identifying added, changed, removed, and renamed files and behavior.
---

# Release Changelog

Use this skill when the user asks to create release notes or a changelog for a regular release, hotfix, bugfix, or patch, or inspect what changed in a version tag. These all use the same tag comparison workflow; the release type changes how findings are grouped and emphasized, not how the diff is calculated. The default comparison is the target tag against its immediately preceding release tag on the same release history.

## Resolve the tag range

1. Read applicable `AGENTS.md` and repository release or changelog conventions. Inspect the working tree and preserve existing edits.
2. Confirm the exact target tag exists locally and resolves to a commit. Do not fetch tags or alter refs unless the user asks.
3. If the user provides both tags, use that exact range. If only a target is provided, find the closest earlier version tag on the target's first-parent history. Prefer the same release line and respect prerelease ordering. If several plausible baselines remain, ask which one to use rather than silently comparing unrelated release branches.
4. State the base and target tags used. If the tags are not on the same ancestry, explain that the tree diff is still a direct comparison but the commit list may include branch-specific history.
5. Do not check out tags or reset the user's worktree. Inspect tag objects and trees directly with Git.

If the target tag is absent locally, report that and ask before fetching or using a different ref. Do not substitute a branch name or a similarly named tag without saying so.

## Inventory file changes

Use the included helper to collect a consistent inventory and commit list once the base and target tags are resolved:

```bash
skills/release-changelog/scripts/inspect-release.sh <base-tag> <target-tag>
```

Run it from anywhere inside the target repository, with both tags available locally. It only reads Git objects; it does not fetch, check out tags, or change files or refs. It reports whether the base is an ancestor of the target. Treat a non-ancestor result as a cue to inspect the release branches before interpreting the commit list. If a tag is missing, stop and follow the missing-tag guidance above.

Use the helper's inventory as a starting point, then inspect relevant diffs to understand user-visible behavior. Git status codes are:

- `A`: added.
- `M`: modified.
- `D`: deleted.
- `R`: renamed; report old and new paths.
- `C`: copied, when Git detects it.
- `T`: file type or mode changed.

Commit messages and file names are clues, not proof. Follow important changes through affected callers or configuration when behavior is not clear from the diff. Distinguish confirmed behavior from an implementation-only change or an uncertain inference.

Report both a concise behavior summary and the requested file-level Added / Changed / Removed / Renamed inventory. Do not treat a rename as an unrelated deletion and addition unless that is clearer for the chosen changelog format.

## Write the changelog

- If the repository already has a changelog, follow its format and place the target release in the correct position without overwriting unrelated sections.
- Otherwise create `CHANGELOG.md` with the target release heading and sections that fit the actual changes, such as **Added**, **Changed**, **Fixed**, and **Removed**.
- Describe user-visible impact in plain language. Keep implementation details only when they help a maintainer or user understand compatibility, migration, configuration, or operational impact.
- For hotfixes, bugfixes, and patches, lead with a **Fixed** section when the tag diff confirms fixes. Explain the user-visible symptom and corrected behavior, and include affected versions or workarounds only when repository evidence supports them. Keep genuine Added, Changed, or Removed items in their own sections; do not classify every change as a fix just because the tag is named `hotfix` or `bugfix`.
- Do not invent dates, issue references, fixes, or behavior. Use a date only when established by repository metadata or supplied by the user.
- Preserve the exact version tag. Do not create, move, or delete Git tags, commits, or release artifacts.

## Review and report

Inspect the generated changelog diff to confirm the comparison range, sections, and claims match the tag contents. Do not run tests for documentation generation. Report the base and target tags, the Added / Changed / Removed / Renamed summary, the changelog file changed, and any uncertainty such as missing local tags or non-ancestor history.
