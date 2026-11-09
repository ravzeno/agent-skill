---
name: change-impact-analysis
description: Trace the likely effects of a proposed or completed backend change across callers, API contracts, business flows, data, configuration, and tests before implementation or release.
---

# Change Impact Analysis

Use this skill when the user asks what a code change may affect, whether a change is safe, what else needs updating, or what to inspect before or after changing a backend service. The default output is a read-only assessment and a focused checklist, not an implementation.

For a concrete defect investigation, use `diagnosing-bugs`. For an actionable review of a diff, use `code-review`. For implementing the requested behavior, use `spring-boot-feature`.

## Define the change and baseline

1. Read applicable repository instructions and identify the target service, module, branch, and working-tree state.
2. Clarify the change being analyzed from the user's description or diff. Distinguish the intended behavior from incidental implementation details.
3. Identify the baseline: current code, staged/unstaged diff, a commit, or a proposed change. Say which one you used.
4. Inspect the change entry point and follow actual references and data flow. Search for callers, routes, DTOs, service methods, mappers, repositories, configuration keys, and tests instead of assuming names imply behavior.
5. When the request spans several services, map only the concrete interfaces and dependencies supported by repository evidence. Do not claim to know external consumers that are not present.

Read relevant glossary entries when the repository has a `GLOSSARY.md`, and inspect ADRs or decision records near the affected area when they explain a contract or architectural choice. Use the repository's domain terms consistently and distinguish written decisions from assumptions.

## Trace affected surfaces

Assess the surfaces that the change can reach:

- **Callers and entry points:** controllers, scheduled jobs, message consumers, internal clients, or public consumers.
- **Contracts:** routes, schemas, DTOs, serialization, status and error responses, generated clients, and backward compatibility.
- **Business flows:** conditional branches, state transitions, eligibility rules, payment or transaction steps, and downstream decisions.
- **Persistence:** entities, repository queries, constraints, transaction boundaries, data migrations, historical records, and read/write consistency.
- **Integrations:** external API calls, event payloads, idempotency, timeout/retry behavior, and failure handling.
- **Security and privacy:** access control, data exposure, validation at trust boundaries, secrets, and sensitive logging.
- **Configuration and operations:** feature flags, environment properties, profiles, deployment configuration, startup requirements, metrics, and alerting.
- **Tests and documentation:** affected unit, integration, contract, or end-to-end coverage and any operational instructions that become inaccurate.

Follow only plausible paths evidenced by the code. Distinguish a direct effect from a possible downstream effect. Check whether existing guards, adapters, or consumers already handle the behavior before calling something a risk.

## Evaluate risk and compatibility

For each affected surface, describe:

- What changes for it.
- Which evidence in the repository supports that conclusion.
- What could fail and under what conditions.
- Whether it is a confirmed dependency, a likely dependency, or an unknown external dependency.
- What mitigation or verification would reduce the risk.

Use confidence labels in plain language where useful: **confirmed** for a direct reference or contract in the repository, **likely** for a supported but indirect flow, and **unknown** for external consumers or runtime behavior not visible in the available evidence.

Pay special attention to changes involving nullability, identifiers, status values, uniqueness, ordering, financial amounts, authorization, retries, asynchronous work, or persisted data. Do not overstate risk merely because a file is nearby. Do not recommend broad refactoring unless the change reveals a concrete dependency that makes the narrow change unsafe.

## Produce a practical assessment

Organize the response into:

1. **Summary:** what behavior is changing and overall risk in plain language.
2. **Affected flow:** a compact path from entry point through the relevant layers.
3. **Impact table or grouped list:** affected component, evidence, risk, and recommended action.
4. **Compatibility/data/config notes:** only if relevant.
5. **Verification checklist:** targeted checks tied directly to the identified risks.
6. **Unknowns:** external consumers or runtime facts that cannot be established from the repository.

Use exact file paths and symbols where available. Label assumptions explicitly. Do not make code changes, run migrations, change deployment settings, or contact external systems unless the user asks for that next step.
