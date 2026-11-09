---
name: spring-boot-feature
description: Implement or extend Java Spring Boot backend features, APIs, integrations, and business logic by following the target repository's existing conventions.
---

# Spring Boot Feature Work

Use this skill when a task asks to add or change backend behavior in a Java Spring Boot service: REST endpoints, request and response models, validation, business rules, persistence, integrations, mappings, configuration, or service-level features.

For a request limited to diagnosing an existing failure, use `diagnosing-bugs`. For a review without implementation, use `code-review`. For a read-only assessment of likely affected code, use `change-impact-analysis`.

## Start with the repository

1. Find the actual repository root and read applicable `AGENTS.md`, contribution notes, and build documentation before editing.
2. Inspect the working tree and preserve existing user changes. Read the relevant source, tests, configuration, and nearby implementations before deciding how the feature fits.
3. Identify the stack and conventions from the repository itself: Java and Spring versions, Maven or Gradle, package layout, controller/service/repository boundaries, DTO and mapper patterns, error handling, validation, logging, and test style.
4. Search for the closest existing feature or endpoint and follow its established style unless the task explicitly calls for a change. Do not assume that sibling services share identical conventions.
5. Convert the request into observable behavior. Record the inputs, outputs, authorization expectations, business rules, edge cases, and compatibility requirements that are explicit or can be safely inferred. Ask only when a missing decision would materially change the implementation.

If the repository has a `GLOSSARY.md`, read relevant entries before naming or changing domain concepts. Check nearby ADRs or decision records when the change touches an established architectural choice. Treat these as project context, not as a reason to broaden the requested change.

## Trace the behavior before editing

Follow the feature through the layers that actually participate. A common path is:

`HTTP/controller -> request validation -> application/service logic -> repository or external client -> mapping -> response`

This is a guide, not a required architecture. Keep the change in the layers the project already uses. Look for:

- Existing routes, request models, response models, validation annotations, and exception conventions.
- Related domain entities, repository queries, transaction boundaries, and data constraints.
- Existing integrations and client wrappers, including timeout and error translation behavior.
- Feature flags, environment-backed properties, security rules, and dependency injection configuration.
- Similar tests and fixtures that reveal expected semantics.

Do not introduce a new abstraction, library, architectural layer, or broad refactor just to make a narrow feature fit a preferred pattern. Reuse an existing abstraction when it genuinely represents the same behavior.

## Implement the smallest complete change

- Preserve API compatibility unless the request authorizes a contract change. Consider field names, nullability, status codes, error response shape, serialization, and downstream callers.
- Put business decisions in the established application/service layer rather than growing controllers with domain rules.
- Reuse existing validation and error handling. Validate at the boundary and keep domain invariants enforced where the project expects them.
- Match repository conventions for transactions, mapping, persistence, logging, and dependency injection.
- Keep external calls behind the project's established client or gateway layer. Preserve existing timeout, retry, and exception behavior unless changing it is part of the task.
- Avoid logging credentials, tokens, personal data, payment data, or full request/response bodies. Follow the service's existing safe logging conventions.
- Update configuration and documentation only when the feature requires it. Do not add sample secrets or fabricated production values.
- Keep unrelated formatting and cleanup out of the diff.

Work in small vertical slices that cross the real behavior path. For each slice, connect one observable behavior to its implementation and the most relevant verification point before moving to the next. This keeps implementation tied to the request and exposes misunderstandings early. Use test-first work when the user requests it or when it is the repository's established workflow; do not invent product behavior just to fill out a test matrix.

## Consider behavior and edge cases

For each changed path, consider the cases relevant to the request and codebase, such as missing or malformed input, absent records, duplicate requests, boundary values, disabled features, authorization failures, downstream timeouts, and partial failures. Do not add speculative behavior that changes product semantics; identify the uncertainty and ask when it cannot be resolved from local evidence.

For persistence or contract changes, consider whether the repository requires a migration, index, schema change, generated client update, or compatibility step. Do not silently make destructive data changes.

## Verification and handoff

Follow user instructions and repository guidance for verification. When verification is requested or is part of the task, choose focused checks relevant to the changed behavior, such as targeted unit tests, module tests, compilation, formatting, or an API-level check. Do not claim a check passed unless it ran successfully. If the environment prevents a check, report the exact limitation.

Before finishing:

- Review the diff for scope, correctness, accidental generated files, and sensitive data.
- Summarize the behavior changed and the main files or layers touched.
- State verification performed and its result, including anything not run.
- Call out assumptions or compatibility risks that the user needs to know.
