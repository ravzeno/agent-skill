# Working in this skills collection

- Treat `skills/` as the source of truth for individual skills. Keep each skill self-contained in `skills/<skill-name>/`.
- When asked to create a skill, clarify its intended users and trigger only if that cannot reasonably be inferred; otherwise create it directly.
- Use the smallest structure that supports the skill. Add `agents/openai.yaml`, scripts, references, or assets only when they serve a concrete purpose.
- Preserve user authorization boundaries. A skill documents task guidance; it does not grant permission for external actions.
- Keep `README.md`'s skill index current when adding, renaming, or removing a skill.
- Before changing an existing skill, inspect its full contents and preserve unrelated instructions.
