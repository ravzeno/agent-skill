---
name: code-review
description: Review code changes across languages and stacks for actionable bugs, regressions, security or data risks, and missing behavior without implementing fixes unless asked.
---

# Code Review

Use this skill when the user asks to review a diff, branch, commit, pull request, service, or specific implementation. Focus on actionable findings that could cause incorrect behavior or meaningful operational risk. A review is an assessment; do not edit or apply fixes unless the user also asks for them.

For a read-only assessment of which components a proposed change may affect, use `change-impact-analysis`. For implementing a feature, use the relevant implementation skill.

## Establish the review scope

1. Read applicable `AGENTS.md`, project conventions, review instructions, and relevant requirements or design notes.
2. Identify the requested scope: unstaged changes, staged changes, a commit, a branch against a base, named files, or a broader service review. Do not silently substitute one scope for another.
3. Inspect repository status and the full relevant diff. Include surrounding source and callers needed to judge behavior. Preserve all working-tree changes.
4. If the requested comparison base is ambiguous, infer it only when repository context makes it clear; otherwise state the scope used or ask a concise question if the answer changes the findings.
5. For a broad project review, prioritize changed and high-risk paths rather than returning generic observations about every file.

For a branch review with a fixed base, verify that the base resolves and use the repository-appropriate merge-base comparison (commonly `git diff <base>...HEAD`). Record the reviewed commit range and changed-file list. If the reference is invalid or the requested diff is empty, report that before drawing conclusions. For a named commit or staged/unstaged review, use the corresponding exact diff rather than silently switching to a branch-wide comparison.

## Separate requirements from standards

Identify the originating issue or spec when available in the request, commit messages, or repository documentation. Also find relevant coding standards and architecture guidance, including ADRs where they apply. Assess requirements and standards separately:

- **Requirements:** is the requested behavior implemented, and is behavior missing, partial, or outside the stated scope?
- **Standards:** does the change follow documented conventions and relevant architectural decisions?

Repository standards take precedence over generic style preferences. If there is no spec or standard for an axis, say so and review only against available evidence. Do not invent requirements from a branch name or infer intent from implementation alone.

## Look for concrete failures

Prioritize defects that can cause incorrect behavior, regressions, security exposure, data loss or corruption, compatibility breaks, resource leaks, or operational failures. Review only dimensions relevant to the change:

- **Behavior and edge cases:** incorrect conditions, null or empty handling, boundary values, duplicate requests, ordering, pagination, time zones, rounding, or inconsistent state transitions.
- **Interfaces and contracts:** route or API compatibility, request and response schemas, serialization, status codes, validation, error shape, and consumer assumptions.
- **Authorization and security:** authentication or permission gaps, trust-boundary mistakes, unsafe input handling, secret exposure, sensitive-data logging, and insecure defaults.
- **Persistence and transactions:** wrong filters or joins, lost updates, duplicate creation, transaction scope, constraint violations, migration compatibility, and data integrity.
- **Integrations:** request construction, idempotency, timeout handling, retry safety, response parsing, failure translation, and correlation or audit logging.
- **Wiring and configuration:** dependency injection, module registration, conditional configuration, environment/profile behavior, defaults, and configuration values.
- **Concurrency and resilience:** races, shared mutable state, unbounded work, resource leaks, retries that multiply side effects, and blocking operations in constrained threads.
- **Verification:** whether important changed behavior and failure cases are covered, and whether checks are brittle or likely to hang. Do not run tests unless the user asks to test or verify the implementation.

Trace behavior through callers and downstream effects. A suspicious line is not a finding until its impact is supported by code or a reproducible failure. Distinguish confirmed defects from risks or questions.

## Report findings

Start with findings ordered by severity. For each actionable finding, include:

- A short severity label consistent with repository conventions, or `[P1]`/`[P2]`/`[P3]` if none exist.
- The precise changed file and line range where the issue can be fixed.
- The triggering scenario and concrete impact.
- The code path or relevant requirement that explains why the issue occurs.
- Any assumption the finding depends on.

When reviewing against a spec, cite or summarize the relevant requirement so the user can see why behavior is missing or mismatched. Keep standards findings and requirement findings separate; a pass on one does not hide a failure on the other.

Report only actionable issues. Do not use findings for naming preferences, speculative style opinions, or behavior already handled elsewhere. If no actionable findings are supported, say so and mention significant areas not covered.

Keep review-only work read-only: do not edit files, stage, commit, push, deploy, or alter external state unless the user explicitly asks for that follow-up. Avoid printing secrets or personal data found in configuration or logs. Do not claim checks passed unless they were run; a code review can normally be static.

Finish with a short summary of the scope and comparison used, checks actually performed, and important coverage limits or assumptions.
