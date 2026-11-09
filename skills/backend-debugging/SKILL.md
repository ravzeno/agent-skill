---
name: backend-debugging
description: Diagnose and fix failures in Java or Spring Boot backend services, including runtime errors, dependency injection, builds, generated code, database queries, integrations, and hanging tests.
---

# Backend Debugging

Use this skill when the user reports a backend failure, exception, unexpected response, build problem, missing Spring bean, generated-code issue, slow or hanging test, or a behavior that stopped working. Aim to establish a cause from repository and runtime evidence before changing code.

If the user asks only for likely affected components without diagnosing a concrete failure, use `change-impact-analysis`. If the task is to add new behavior, use `spring-boot-feature`.

## Establish the failure precisely

1. Read the repository's `AGENTS.md`, project instructions, and relevant build/run documentation.
2. Inspect the working tree before changing files. Preserve user edits and distinguish them from the failure under investigation.
3. Capture the exact observed symptom: command, failing test, stack trace, HTTP status/body, log excerpt, or steps to reproduce. Identify what was expected and what happened.
4. Locate the affected module and determine the actual runtime/build versions and toolchain from project files. Do not assume a sibling service uses the same setup.
5. Reproduce with the narrowest reliable command when the user has asked for debugging or verification and the environment supports it. Preserve the full first useful error; later errors may be cascades.

When reproduction is unavailable, state which evidence is available and continue with static tracing. Do not present a hypothesis as a confirmed cause.

Redact credentials, tokens, personal data, payment details, and authorization headers before showing commands, logs, or captured artifacts. Keep secrets in the environment rather than embedding them in a command or report. If redaction removes the evidence needed to distinguish causes, ask for a safer, more focused artifact.

## Build a useful feedback loop

Spend effort on a fast, focused signal that exercises the failing path. Prefer, in order, a targeted test, a local HTTP/API reproduction, a CLI or fixture-driven reproduction, a small harness, or a bounded manual procedure. Use the narrowest loop that can detect the reported symptom; avoid starting with a full suite when a smaller check can answer the question.

Before treating the failure as understood, check that the signal:

- Exercises the same behavior the user reported.
- Distinguishes the failure from unrelated setup errors.
- Has a clear pass/fail observation, such as the exact response, assertion, exception, or measured latency.
- Can be run safely and within a bounded amount of time.

For intermittent issues, record the reproduction rate and the conditions that affect it. Improve repeatability with controlled inputs, isolated dependencies, or bounded repetitions when that is safe. Do not turn an unbounded or costly loop into the default diagnostic.

If no meaningful reproduction can be built, state what you tried and what evidence is missing. Continue with clearly labeled static hypotheses only when useful; do not claim the root cause is proven.

## Trace from symptom to cause

Move from the failing boundary inward:

- For startup or dependency injection failures, inspect the failing bean's constructor and configuration, component scanning, conditional properties, profiles, bean definitions, and dependency versions.
- For missing generated classes such as QueryDSL `Q*` types, inspect the annotation processor, generated-sources configuration, source-set inclusion, build plugin versions, and whether generation runs before compilation. Confirm whether the generated output is absent or merely excluded from the IDE.
- For test failures, compare the failing test's setup and fixtures with the code path, inspect the first assertion or exception, and check async work, external dependencies, resource cleanup, and timeouts before changing the timeout.
- For database or query issues, trace the input and filters through repository methods, entity mappings, joins, null handling, and database constraints. Verify the actual query semantics rather than inferring from method names.
- For integration failures, inspect the request construction, configuration, timeout, response parsing, and exception translation. Keep secrets and personal data out of logs and command output.
- For incorrect business behavior, trace the value from the entry point through transformations, conditions, and persistence or response mapping. Compare the actual path with nearby working behavior.
- For build or dependency failures, inspect the exact tool command, module selection, wrapper version, plugin configuration, compiler flags, and dependency resolution output.

Search for the symbol, exception type, and closest working equivalent. Read enough surrounding code to verify assumptions. Do not change unrelated layers based only on a stack-trace line when the underlying cause may be earlier in the call chain.

## Use evidence-driven hypotheses

List a few ranked, falsifiable hypotheses before changing code. For each one, state what observation would support it and what small probe could disprove it. Prefer one diagnostic step that separates competing explanations, and change one variable at a time. Share the leading hypotheses with the user when their domain knowledge could reorder them, while continuing independent investigation when possible.

Do not pile on speculative fixes such as changing several versions, disabling checks, broadening component scans, or increasing timeouts without evidence.

A useful diagnosis explains:

- The triggering condition.
- The code or configuration path that produces the failure.
- Why the observed error follows from that path.
- The smallest safe correction and its scope.

When certainty is incomplete, label the result as a likely cause and say what additional log, environment value, or reproduction would confirm it.

## Fix with a narrow change

When the user asked for a fix, make the smallest change that corrects the demonstrated cause while preserving existing behavior. Follow project conventions. Avoid suppressing the symptom if the root cause is fixable. Do not remove tests, weaken validation, disable security, or hide exceptions to make a failure disappear.

If the fix requires changing a contract, persistent data, an external service, or production configuration, explain the implications and keep the change within the user's request. Do not perform external mutations unless clearly authorized.

When the failure has a suitable test seam, add or update a regression check that captures the reported behavior and confirm it distinguishes the broken behavior from the corrected one. If no suitable seam exists, explain what the available checks do and do not cover rather than adding a test that only mirrors implementation details.

## Verify and report

Follow repository instructions and the user's requested level of verification. Run the smallest relevant check when requested or necessary to demonstrate the fix. For a hanging test, prefer understanding its blocking point and use bounded diagnostics; do not repeatedly rerun an unbounded command. Remove temporary probes, tagged debug logging, and throwaway harnesses that are not part of the fix. Re-run the original focused feedback loop after the change when feasible, then use any broader check required by the repository or requested by the user.

Report:

- What failed and the evidence used.
- Root cause, or clearly labeled best-supported hypothesis.
- The files or settings changed and why.
- Verification performed and its outcome.
- Any remaining uncertainty or environment-specific limitation.
