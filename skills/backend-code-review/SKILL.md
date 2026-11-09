---
name: backend-code-review
description: Review Java and Spring Boot backend changes for concrete bugs, regressions, security issues, data risks, and missing behavior without implementing fixes unless asked.
---

# Backend Code Review

Use this skill when the user asks to review a diff, branch, commit, service, or a specific backend implementation. Focus on actionable findings that could cause incorrect behavior or meaningful operational risk. A review is an assessment; do not edit code or apply fixes unless the user also asks for them.

For a read-only assessment of which components a proposed change may affect, use `change-impact-analysis`. For implementing a feature, use `spring-boot-feature`.

## Set the review scope

1. Read applicable `AGENTS.md`, project conventions, and review instructions.
2. Identify the requested scope: unstaged changes, staged changes, a commit, a branch against a base, named files, or a broader service review. Do not silently substitute one scope for another.
3. Inspect repository status and the full relevant diff. Include surrounding source and callers needed to judge behavior. Preserve all working-tree changes.
4. If the requested comparison base is ambiguous, infer it only when repository context makes it clear; otherwise state the scope used or ask a concise question if the answer changes the findings.
5. For a broad project review, prioritize changed and high-risk paths rather than returning generic observations about every file.

For a branch review with a fixed base, verify that the base resolves and use the repository-appropriate merge-base comparison (commonly `git diff <base>...HEAD`). Record the reviewed commit range and changed-file list. If the reference is invalid or the requested diff is empty, report that before drawing conclusions. For a named commit or staged/unstaged review, use the corresponding exact diff rather than silently switching to a branch-wide comparison.

## Separate standards from requirements

Identify the originating issue or spec when one is available in the user's request, commit messages, or repository documentation. Also find the project's coding standards and architecture guidance, including relevant ADRs. Assess these as separate questions:

- **Requirements:** is the requested behavior implemented, and is any behavior missing, partial, or outside the stated scope?
- **Standards:** does the change follow documented conventions and relevant architectural decisions?

Repository standards take precedence over generic style preferences. If there is no spec or standard for an axis, say so and review only against the evidence available. Do not invent requirements from a branch name or infer intent from implementation alone.

## Review for concrete failure modes

Check the parts relevant to the change:

- **Behavior and edge cases:** incorrect conditions, null or empty handling, boundary values, duplicate requests, ordering, pagination, time zones, rounding, or inconsistent state transitions.
- **API contracts:** route, request/response compatibility, serialization, status codes, validation, error shape, and assumptions made by consumers.
- **Authorization and security:** authentication or permission gaps, trust-boundary mistakes, unsafe input handling, secret exposure, sensitive data logging, and insecure defaults.
- **Persistence and transactions:** wrong filters or joins, lost updates, duplicate creation, transaction scope, constraint violations, migration compatibility, and data integrity.
- **Integrations:** request construction, idempotency, timeout handling, retry safety, response parsing, failure translation, and correlation or audit logging.
- **Spring wiring and configuration:** bean scope, conditional configuration, profile behavior, component scanning, property defaults, and dependency injection.
- **Concurrency and resilience:** races, shared mutable state, unbounded work, resource leaks, retries that multiply side effects, and blocking operations in constrained threads.
- **Tests:** whether important changed behavior and failure cases are covered, whether assertions match product behavior, and whether tests are brittle or likely to hang.

Trace behavior through callers and downstream effects. A suspicious line is not a finding until its impact is supported by the code or a reproducible failure. Distinguish a confirmed defect from a risk or question.

## Write useful findings

Order findings by severity, highest first. For each finding, include:

- A short severity label consistent with repository conventions, or a simple `[P1]`/`[P2]`/`[P3]` label if none exist.
- The precise file and line range in the reviewed diff where the issue can be fixed.
- The triggering scenario and the concrete impact.
- A concise explanation of why the current code produces that outcome.

When reviewing against a spec, cite the relevant requirement or summarize its exact meaning so the user can see why the implementation is missing or mismatched. Keep standards findings and requirement findings in separate groups; do not let a pass on one axis hide a failure on the other.

Report only actionable issues. Do not use findings for naming preferences, speculative style opinions, or behavior that is already handled elsewhere. If a concern depends on an assumption, state that assumption. If the code is sound within the requested scope, say that no actionable findings were found and mention significant areas not covered.

## Keep review-only work read-only

Do not modify files, stage changes, commit, push, deploy, or alter external state during a review unless the user explicitly requests that follow-up. Avoid printing secrets or personal data found in configuration or logs. Do not claim tests or builds passed unless you ran them; normally a code review can be static and need not run the full suite.

## Review response format

Start with findings, highest severity first. Then give a short review summary with:

- Scope and comparison used.
- Verification or commands performed, if any.
- Important coverage limits or assumptions.

Keep the response concise enough to act on while including enough context to reproduce each issue.
