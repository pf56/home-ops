## 1. Add repository-wide agent guidance

- [x] 1.1 Create the root `AGENTS.md` with the project's purpose and a concise map of the `nix/`, `infrastructure/`, `kubernetes/`, and `openspec/` areas.
- [x] 1.2 Add durable working rules covering declarative source-of-truth changes, generated files, encrypted and sensitive files, relevant validation, and preservation of unrelated worktree changes.
- [x] 1.3 Add the nono operator-handoff policy: do not bypass or automatically widen the sandbox, access SSH or raw credentials, or claim unavailable remote or destructive work succeeded; provide manual steps with verification and rollback or cancellation guidance.

## 2. Align OpenSpec workflow guidance

- [x] 2.1 Replace the general project context in `openspec/config.yaml` with concise OpenSpec-specific rules for task verification and operator handoffs.
- [x] 2.2 Add the rule to review and update `AGENTS.md` when durable repository structure, source-of-truth boundaries, or universal workflows change, while excluding temporary task details and omitting an `AGENTS.md` pointer.

## 3. Validate and review the documentation change

- [x] 3.1 Generate OpenSpec artifact and apply instructions for the change and confirm they contain the new workflow rules without the removed duplicated project context.
- [x] 3.2 Run `openspec validate add-repository-agent-guidance` and `git diff --check`.
- [x] 3.3 Review the final files for concise scope, absence of plaintext secrets, explicit distinction between verified and operator-performed work, and no changes to nono profiles or runtime configuration.
