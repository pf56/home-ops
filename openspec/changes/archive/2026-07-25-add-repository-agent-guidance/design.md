## Context

The repository is a declarative personal homelab managed across NixOS and Home Manager configuration, OpenTofu infrastructure, Talos configuration, and GitOps-managed Kubernetes applications. General project context currently lives in `openspec/config.yaml`, which OpenSpec injects into artifact instructions but which is not a general repository onboarding document.

The agent runs through a nono sandbox. The sandbox profile is the mechanism that enforces filesystem, network, and credential capabilities; the repository guidance should define agent behavior and operator handoff, not duplicate profile internals or silently widen permissions. The current profile and Grafana MCP integration remain unchanged by this work.

## Goals / Non-Goals

**Goals:**

- Provide a concise root `AGENTS.md` with the repository's purpose, structure, durable conventions, validation expectations, and sensitive-data rules.
- Make the general project context available to any agent harness that loads `AGENTS.md`.
- Keep OpenSpec context focused on workflow-specific rules rather than duplicating the repository overview.
- Define safe behavior when a task requires credentials, remote access, destructive actions, or sandbox capabilities unavailable to the agent.
- Ensure OpenSpec tasks distinguish completed and verified work from operator handoffs and blocked work.
- Keep `AGENTS.md` current when durable repository structure or universal workflows change.

**Non-Goals:**

- Changing the nono profile, its filesystem or network grants, or its credential routes.
- Granting agents SSH access or enabling them to perform remote administration.
- Changing NixOS, OpenTofu, Talos, Kubernetes, Helm, Argo CD, or Grafana runtime behavior.
- Adding a large command catalog, generic coding-style guide, or detailed nono documentation to `AGENTS.md`.
- Requiring `AGENTS.md` updates for local implementation details or temporary task context.

## Decisions

### Use a concise root AGENTS.md as the canonical general guide

Create one root `AGENTS.md` organized around project purpose, repository map, working rules, validation, and sandbox/operator handoff. Keep it concise and limited to information that applies broadly to repository tasks. Prefer references to authoritative repository files over copied implementation details.

Alternative considered: maintain all agent context in `openspec/config.yaml`. This would leave non-OpenSpec agents without the project map and safety rules.

Alternative considered: add detailed guidance files immediately under an agent documentation directory. This is unnecessary for the current scope; progressive disclosure can be added later if the root guide becomes too large.

### Move general context out of OpenSpec and retain workflow-specific rules

Remove the general project map and conventions from `openspec/config.yaml`. Retain concise OpenSpec rules covering task verification, operator handoff, and reviewing `AGENTS.md` after durable repository changes. Do not add a pointer to `AGENTS.md`, because the normal agent harness already injects it and the pointer would not provide its contents to other consumers.

Alternative considered: duplicate the full guide in both files. This would increase prompt size and create drift between two sources of truth.

Alternative considered: remove all context from `openspec/config.yaml`. This would lose OpenSpec-specific workflow constraints for consumers that use its instructions directly.

### Treat blocked or privileged work as an explicit operator handoff

When an operation needs unavailable credentials, remote access, destructive authority, or a denied sandbox capability, the agent must not silently skip it, claim success, or automatically expand the profile. The task should describe the manual operator action, prerequisites, command or procedure, expected verification, and rollback or cancellation path. The task remains incomplete until the operator performs and verifies the action.

Alternative considered: recommend profile allowlisting as the default remedy. This is inappropriate for SSH, credential handling, remote administration, and destructive operations. Safe read-only access can be discussed only when the operator explicitly requests it.

### Maintain AGENTS.md only for durable repository-wide knowledge

The OpenSpec instructions should require a review of `AGENTS.md` when a change modifies general structure, source-of-truth boundaries, or universal workflows. Updates should be made in the same change only when the guide becomes inaccurate or incomplete. Temporary operational details and task-specific implementation notes remain in the relevant OpenSpec artifacts.

## Risks / Trade-offs

- [Risk] The root guide becomes too long and agents ignore important rules. -> Keep only universal guidance and move detailed procedures to authoritative files or future progressive-disclosure documents.
- [Risk] `AGENTS.md` and OpenSpec context drift. -> Make `AGENTS.md` the general source of truth and keep only OpenSpec-specific rules in `openspec/config.yaml`.
- [Risk] An agent claims a remote or destructive task is complete without performing it. -> Require explicit operator handoff records and verification before marking tasks complete.
- [Risk] The sandbox policy is misunderstood as a command allowlist. -> Describe nono as a capability boundary without duplicating profile configuration details.

## Migration Plan

1. Add the root `AGENTS.md` with the approved repository and operator guidance.
2. Replace the general `context` content in `openspec/config.yaml` with the concise OpenSpec-specific rules.
3. Validate the OpenSpec configuration and inspect the generated instructions to confirm the workflow rules are present.
4. Review the resulting files for duplication, accidental secret content, and appropriate scope.

There is no runtime rollback or deployment migration. If the guidance is incorrect, revert the documentation change or update the affected artifact.

## Open Questions

- None. The current scope intentionally leaves nono profile behavior unchanged.
