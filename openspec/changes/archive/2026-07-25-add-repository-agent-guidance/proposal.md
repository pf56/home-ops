## Why

The repository has useful project context in `openspec/config.yaml`, but no repository-wide onboarding document for coding agents. Agents also need consistent guidance for declarative infrastructure work and for handing off sandbox-limited or sensitive operations to the operator without attempting to bypass the boundary.

## What Changes

- Add a concise root `AGENTS.md` describing the repository purpose, structure, durable engineering conventions, validation expectations, and sensitive-file handling.
- Move general project context from `openspec/config.yaml` into `AGENTS.md` so it is available to all supported agent harnesses.
- Keep `openspec/config.yaml` focused on OpenSpec-specific workflow guidance rather than duplicating `AGENTS.md` or nono profile documentation.
- Instruct agents to review and update `AGENTS.md` when durable repository structure, source-of-truth boundaries, or universal workflows change, while excluding temporary task details.
- Define an operator handoff for operations requiring credentials, remote access, destructive actions, or capabilities unavailable inside the nono sandbox.
- Require agents to distinguish performed and verified work from blocked or operator-performed work, without changing the nono profile or automatically widening its permissions.

## Capabilities

### New Capabilities

- `repository-agent-guidance`: Repository-wide onboarding, safety, validation, and operator-handoff guidance for coding agents.

### Modified Capabilities

<!-- No existing capability requirements are changing. -->

## Impact

- Adds the root `AGENTS.md` file.
- Changes the general context and workflow instructions in `openspec/config.yaml`.
- Changes the instructions available when OpenSpec artifacts are created or applied.
- Does not change NixOS, Kubernetes, infrastructure, nono profiles, credentials, or runtime deployment behavior.
