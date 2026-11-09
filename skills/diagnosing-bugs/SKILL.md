---
name: diagnosing-bugs
description: Diagnose and fix reported software failures across languages and stacks, including runtime errors, builds, generated code, database queries, integrations, and hanging operations.
---

# Diagnosing Bugs

Use this skill when the user reports a failure, exception, unexpected response, build problem, missing generated code, slow or hanging operation, or behavior that stopped working. Establish the cause from repository and runtime evidence before changing code.

If the user asks only which components a proposed change may affect, use `change-impact-analysis`. If the task is to add new behavior rather than diagnose an existing failure, use the relevant implementation skill such as `spring-boot-feature`.

## Define the failure

1. Read applicable `AGENTS.md`, project instructions, and relevant build or run documentation.
2. Inspect the working tree before changing files. Preserve user edits and distinguish them from the failure under investigation.
3. Capture the exact symptom from the report, command, stack trace, response, logs, or steps to reproduce. Identify what was expected and what happened. Preserve the first useful error; later failures may be cascades.
4. Locate the affected module and determine actual runtime, build, and toolchain versions from project files. Do not assume sibling modules or services use the same setup.
5. When reproduction or verification is within the user's request, use the narrowest reliable signal that exercises the failing path. If reproduction is unavailable, continue with static tracing and state the limitation; do not present a hypothesis as confirmed.

Redact credentials, tokens, personal data, payment details, and authorization headers before showing commands, logs, or captured artifacts. Keep secrets in the environment rather than embedding them in a command or report. If redaction removes evidence needed to distinguish causes, ask for a safer, focused artifact.

## Find the cause

- Build a useful feedback loop only when requested or needed for the user's verification goal. Prefer a targeted existing check, local request reproduction, CLI or fixture reproduction, small harness, or bounded manual procedure. Avoid a full suite when a smaller signal answers the question.
- Confirm the signal exercises the reported behavior, distinguishes the defect from unrelated setup errors, has a clear pass/fail observation, and can be run safely within a bounded time.
- When the reproduction requires a person to interact with an app, adapt [`scripts/hitl-loop.template.sh`](scripts/hitl-loop.template.sh): replace the example steps and capture questions with the real scenario, save a task-specific copy, then run it with `bash`. Do not run the template unchanged or overwrite the reusable template. Ask the person to redact secrets and personal data before entering captured output.
- For intermittent failures, record how often they reproduce and which conditions affect them. Improve repeatability with controlled inputs or isolated dependencies when safe; do not make an unbounded or costly loop the default.
- Rank a few falsifiable hypotheses by evidence. State what observation would support each and what small probe would disprove it. Prefer a diagnostic step that separates competing explanations, change one variable at a time, and share leading hypotheses when the user's domain knowledge could reorder them.
- Trace the failing value, state, request, or event from the boundary inward to where actual behavior diverges from expected behavior. Search for relevant symbols, error types, and the closest working equivalent. Read enough surrounding code to verify assumptions.
- Check whether the failure comes from environment or setup before changing application code. Do not change unrelated layers based only on a stack-trace line when the cause may be earlier in the call chain.

Inspect the technology-specific path that matches the evidence:

- **Startup and dependency injection:** constructor and configuration, component or module scanning, conditional properties, profiles, dependency registration, and dependency versions.
- **Generated code:** generator or annotation processor, generated-source configuration, source-set inclusion, plugin versions, and whether generation runs before compilation. Determine whether output is absent or only excluded from the editor.
- **Tests or asynchronous operations:** setup and fixtures, first failing assertion or exception, async work, external dependencies, cleanup, and timeouts. Do not increase a timeout before understanding the blocking point.
- **Database and query behavior:** inputs and filters through repository or data-access methods, mappings, joins, null handling, and constraints. Verify query semantics rather than inferring them from method names.
- **Integrations:** request construction, configuration, timeouts, response parsing, retry behavior, and exception translation. Keep sensitive values out of output.
- **Incorrect application behavior:** trace values through entry points, transformations, conditions, persistence, and response mapping; compare with nearby working behavior.
- **Build and dependency failures:** exact command and module, wrapper version, plugin configuration, compiler flags, and dependency resolution output.

Before treating a cause as established, check that the evidence explains the trigger, the code or configuration path, and why the observed error follows. If certainty is incomplete, label the result as a likely cause and identify what additional log, environment value, or reproduction would confirm it.

## Fix and report

If the user asks for a fix, make the smallest change that corrects the supported cause and preserves existing behavior. Follow project conventions. Do not suppress a symptom when the underlying cause can be corrected. Do not remove tests, weaken validation, disable security, or hide exceptions to make a failure disappear.

If a fix requires changing a contract, persistent data, an external service, or production configuration, explain the implications and keep it within the user's request. Do not perform external mutations without clear authorization.

Follow the user's requested verification scope. Do not claim a reproduction, test, or build succeeded unless it was actually run. Do not add or run tests unless the user asks to test or verify the implementation. When verification is unavailable or outside scope, explain what evidence supports the diagnosis and what remains unconfirmed.

Report what failed and the evidence, the confirmed cause or clearly labeled best-supported hypothesis, relevant code or configuration path, files changed and why, verification performed and its outcome, and remaining uncertainty or environment-specific limits. Remove temporary probes and throwaway harnesses that are not part of the fix.
