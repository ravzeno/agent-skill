---
name: feature-workflow
description: Deliver a new or changed software feature end to end with role-based agents, iterative independent review, fixes, and verification until acceptance criteria pass.
---

# Feature Workflow

Use this skill when the user wants to add a feature or change existing feature behavior and expects an end-to-end implementation. Follow the target repository's conventions and the user's requested scope. For a task limited to diagnosing a failure, use `diagnosing-bugs`; for review without implementation, use `code-review`.

## 1. Understand the request and repository

- Find the repository root. Read applicable `AGENTS.md`, contribution guidance, and relevant design docs. Inspect the working tree first and preserve unrelated user changes.
- Trace the requested behavior through the existing code, callers, interfaces, data, configuration, and nearby tests. Identify the stack and follow established patterns rather than assuming an architecture.
- Restate the expected user-visible behavior, important constraints, and acceptance conditions in a compact plan. Separate known requirements from assumptions.
- When there are meaningful implementation choices, present two or three viable approaches in plain language, compare their tradeoffs and risks, recommend one, and ask the user to choose. Wait for the choice before implementing the decision it affects. Ask only questions whose answers could change behavior, compatibility, cost, or scope. If the request is already clear or the choice is minor, state the reasonable assumption and proceed instead of manufacturing a decision gate.
- Once the approach is clear, outline the implementation scope and how success will be verified. Keep this plan concise and proceed; do not ask for a separate approval to do work the user already requested.

## 2. Assign agent roles

The primary agent is the **orchestrator**: it owns the user conversation, selected approach, acceptance criteria, integration, final decisions, and completion report. Delegate bounded work to other agents when collaboration tools are available and the task has separable work; do not add agents just to create activity.

- **Recon agent (read-only):** map relevant modules, callers, contracts, risks, and existing verification patterns. Return evidence and file paths; do not edit.
- **Implementation agent(s):** own a clearly bounded, non-overlapping slice of the feature. Give each agent its files/behavior, interfaces with other slices, acceptance conditions, and verification request. Avoid concurrent edits to the same files; the orchestrator integrates all changes and resolves conflicts.
- **Review agent (fresh chat):** independently review the completed diff, read-only, following section 4. It must not receive implementation reasoning or edit the code.
- **QA agent (read-only):** after review fixes are integrated, run the agreed focused checks and report exact commands, results, and failures. It must not change source code; any fix returns to the orchestrator or an implementation agent.

Use only the roles that fit the task. For a small change, the orchestrator may handle reconnaissance, implementation, and QA itself, but still use the fresh-chat reviewer when available. Agents share a checkout in many environments: define ownership before parallel edits, avoid overlapping file changes, and inspect the combined diff after every agent finishes. Treat agent output as evidence to verify, not as authority to expand scope.

## 3. Implement the selected approach

- Keep the change focused and complete across the layers that participate in the behavior. Preserve existing API and data compatibility unless the request chose a breaking change.
- Work in coherent slices, following repository conventions for validation, authorization, persistence, error handling, configuration, UI, logging, and documentation as applicable.
- Consider relevant failure and boundary cases. Do not invent product behavior to fill gaps; resolve uncertainty from repository evidence or ask when it matters.
- Do not modify unrelated files or overwrite the user's existing changes. Do not stage, commit, push, deploy, or mutate external systems unless the user explicitly requested that action.

## 4. Run an independent code review in a fresh chat

After implementation, inspect the full diff and start a separate, fresh Codex chat/task for a read-only review. This is a required stage of this end-to-end workflow when thread tools are available, and gives the reviewer less exposure to the implementation rationale. Skip creating a review task when no code changed (for example, the request ended at planning).

- Use the Codex thread tools when available: find the project that matches the repository, then create a local project task starting from the current working tree so the reviewer sees the implementation under review. If the app returns a pending setup, wait for the task to become ready before relying on it.
- Give the reviewer the original request and acceptance conditions, applicable repository instructions, the review scope, and the changed diff or working-tree state plus relevant surrounding code. Ask it to inspect independently for actionable behavior defects, regressions, contract/security/data risks, and missing requirements. Require severity and precise file/line evidence. Do not include your design debate, preferred solution, suspected bug, self-review conclusions, or other hints that could anchor the reviewer.
- Make the review task explicitly read-only: it must report findings and must not edit files, stage, commit, push, or publish. Wait for or retrieve its report using the available thread tools. Do not leave the user to relay the findings manually when the tools can return them.
- Assess every finding against the request and code. Fix confirmed, in-scope defects in the implementation context; reject or explain speculative, incorrect, or scope-expanding suggestions. If a change from the review materially changes the selected approach or product behavior, return to the user with the concrete choice before proceeding.
- If the project or working-tree state cannot be attached, provide a read-only snapshot/diff in the new review task if possible. If the thread tools or fresh-chat review are unavailable, do the best available independent review and clearly report the limitation. Never imply a fresh-chat review happened if it did not.

## 5. Iterate until success

- Define success from the request before implementation: all agreed acceptance conditions are met, the fresh-chat review has no unresolved actionable in-scope findings, required focused verification passes, and the final diff is scoped and understood. If the user waives testing or a required check is unavailable, report the work as unverified rather than claiming every success gate passed.
- After each review, address confirmed in-scope findings, then have QA run checks in the implementation context against the resulting code. Follow repository instructions and user constraints. Prefer focused tests for changed behavior, then relevant build, lint, type, or integration checks when useful. Add or update tests when needed to capture the requested behavior and consistent with repository conventions. Do not treat static review as a substitute for running checks.
- If a review finding or check fails, diagnose the cause, make a focused fix, inspect the changed diff, and repeat the independent review and relevant verification for the updated code. Continue this fix → review → verify cycle until the success conditions above hold; a prior passing run does not cover code changed afterward.
- If a fix materially changes the selected approach, acceptance conditions, or product behavior, pause that dependent work and present the concrete choice to the user. If the same failure persists without new evidence or a safe next step, or progress depends on unavailable access, environment, or user input, stop the loop, explain the blocker and work already done, and ask only for the decision or access needed. Never claim success while a required gate is failing or unverified.
- If the user says not to test, honor that. If a check cannot run, report the exact blocker. Do not claim a test or check passed unless it actually ran successfully.
- Reinspect the final diff after fixes and verification. Confirm it still matches the selected approach and contains no unrelated or accidental changes.

## 6. Report completion

Summarize the selected approach and behavior implemented, plus the main areas changed. Report whether the fresh-chat review completed, its findings and how each material finding was handled, and the checks actually run with their results. State remaining assumptions, limitations, or unresolved findings plainly.
