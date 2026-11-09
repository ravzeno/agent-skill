---
name: local-dev-setup
description: Inspect and prepare a backend service's local development setup, including Docker Compose, environment configuration, build commands, dependencies, and safe run instructions.
---

# Local Development Setup

Use this skill when the user asks how to run a service locally, fix a local startup setup, add or update Docker Compose, identify required environment variables, or document local build and run steps.

For diagnosing a specific application failure after startup, use `diagnosing-bugs`. For application feature implementation, use `spring-boot-feature`.

## Inspect before changing setup

1. Read repository and parent-directory `AGENTS.md` files and the project's run/development documentation.
2. Identify the service root, build tool and wrapper, runtime version, existing container files, profiles, config files, and current environment-file conventions.
3. Inspect existing local configuration and Compose files before proposing duplicates. Determine which dependencies are already provisioned and which must run separately.
4. Preserve user changes, existing service names, ports, volumes, health checks, and project naming unless the request requires a change.
5. Separate what is documented, what is configured, and what is inferred. Do not invent database names, credentials, provider URLs, ports, or required properties when repository evidence is missing.

## Build a reliable local run path

When the user asks for setup steps or a Compose change, make the path explicit and consistent with the repository:

- State prerequisites and versions based on build files, wrappers, or documented requirements.
- Identify local dependencies such as databases, caches, message brokers, or mock services and use the existing configuration where possible.
- Map environment variables to configuration properties and explain which are required, optional, or profile-specific when that can be established from source.
- Preserve the distinction between local-only values and production secrets. Use clearly marked placeholders or a checked-in example file only when the repository convention supports it; never create plausible-looking real credentials.
- For Docker Compose, check service dependencies, ports, health checks, persistence volumes, startup order, and local network assumptions. Do not expose a dependency on all host interfaces unless the project already requires it.
- Include the exact build, start, stop, and basic health-check commands appropriate to the actual toolchain. Avoid destructive cleanup commands unless their effect is clearly explained and the user requested that operation.
- Keep local setup isolated from production deployment configuration. Do not silently alter deployment manifests, shared environments, or external services.

## Handle secrets and environment files safely

Treat `.env`, `local.env`, credentials, tokens, certificates, and connection strings as sensitive:

- Do not print secret values in responses or logs. When inspecting a file, report variable names and whether values appear configured; mask values.
- Do not copy secrets into examples, Compose files, documentation, shell history, or generated commands.
- Preserve existing user-provided values. Never replace an existing secret with a placeholder or guessed value.
- Before adding or changing ignore rules, inspect the existing repository rules and avoid hiding unrelated user files.
- If a required value is unavailable, name the missing variable and where the user can obtain it; do not fabricate it.

## Make scoped, understandable changes

- Prefer correcting the existing documented setup over creating a parallel way to run the service.
- Add only the files needed for the requested workflow, such as a Compose file, `.env.example`, or a concise setup section in existing docs.
- Avoid adding dependencies or scripts where the project's existing toolchain already provides the function.
- Explain any host port, data persistence, or startup behavior that affects the developer's machine.
- Do not remove volumes or database data as part of routine troubleshooting.

## Verify and hand off

Follow user and repository instructions for checks. If verification is requested, validate Compose syntax or build/run the narrowest safe local check that does not require unavailable credentials or external access. Do not start services or execute destructive cleanup without the task calling for it. Report commands that were run and whether they succeeded.

Finish with:

- Files or settings changed.
- Prerequisites and environment values still needed, with secret values omitted.
- Exact commands to start and stop the local setup.
- Verification performed and any limitation.
