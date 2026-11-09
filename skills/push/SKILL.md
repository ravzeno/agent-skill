---
name: push
description: Commit and push the user's intended repository changes when they explicitly ask to push or to commit and push. Review the working tree, stage only the intended changes, and confirm the commit message before publishing.
---

# Push

Use this skill when the user explicitly asks to push, or to commit and push, repository changes. A request to review, prepare, or commit without pushing does not authorize a push.

## Workflow

1. Find the repository root and inspect `git status --short --branch`, the current branch, configured remotes, and relevant diffs. Do not assume the current directory is the repository root.
2. Review tracked and untracked changes before staging. Stage only changes that belong to the requested work. Preserve changes already staged by the user; do not reset, discard, or overwrite them. If unrelated changes cannot be separated confidently, ask which changes to include.
3. After staging the intended changes, run [`scripts/push.sh --check`](scripts/push.sh) as a read-only preflight when useful. It reports the branch, confirms a single `origin` URL exists without printing it, lists staged paths, and checks staged whitespace. It does not stage, commit, or push. Inspect the complete staged diff with `git diff --cached` and check for secrets, generated files, or unrelated edits. If there are no staged changes, report that and stop.
4. Draft one concise commit message that describes the staged changes. Present the message with three explicit choices: **ยืนยัน commit**, **แก้ไขข้อความ**, and **ยกเลิก**. If the user edits it, show the revised message and request confirmation again. Wait for explicit confirmation before committing. If an interactive choice prompt is unavailable, ask in chat and wait for an explicit reply. If the user cancels, stop; leave the index as it is.
5. After confirmation, commit with the proposed message. If the commit fails, report the failure and do not push.
6. Confirm the current branch is named and the intended push remote is clear. Use the configured `origin` when present; if the remote is absent or ambiguous, ask the user rather than guessing. Never push from a detached HEAD.
7. Push the current branch to the confirmed remote. Do not force-push, amend, change upstream configuration, or push tags unless the user explicitly requests it.
8. Report the commit hash, branch, remote, and whether the push succeeded. If the commit succeeded but the push failed, make that distinction clear and do not retry in a way that could duplicate or overwrite remote work without inspecting the new state.

A clear user instruction to commit and push authorizes those actions after the commit message confirmation above. Do not ask for a second general confirmation after that confirmation; ask only when a required choice is genuinely unclear.

When using an interactive terminal workflow, [`scripts/push.sh`](scripts/push.sh) implements the same confirm/edit/cancel choices. Pass a proposed message as `scripts/push.sh --message "<message>"`, or let it prompt for one. It commits only already-staged changes and pushes the current branch to the single configured `origin`; it never stages files or force-pushes. Run it only after reviewing the full staged diff and when the user explicitly requested a push. If the terminal is not interactive, use the chat or UI choice flow and the ordinary Git commands instead.
