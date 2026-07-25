## ADDED Requirements

### Requirement: The repository SHALL provide concise general agent guidance

The repository SHALL contain a root `AGENTS.md` that explains the project's purpose, maps the major repository areas, and records durable working and validation conventions applicable to repository-wide agent tasks.

#### Scenario: An agent begins work on a repository task

- **WHEN** the agent receives a task in the repository
- **THEN** the root `AGENTS.md` provides enough project context to identify the relevant configuration area and the expected declarative workflow

#### Scenario: A local implementation detail does not affect general guidance

- **WHEN** a change is limited to one component and does not alter repository-wide structure, source-of-truth boundaries, or universal workflows
- **THEN** the change does not add temporary or task-specific details to `AGENTS.md`

### Requirement: General project context SHALL have one agent-facing source of truth

The repository SHALL keep general project structure, sensitive-file handling, generated-file rules, and universal engineering conventions in `AGENTS.md` rather than duplicating them in `openspec/config.yaml`.

#### Scenario: OpenSpec instructions are generated

- **WHEN** OpenSpec generates artifact or apply instructions
- **THEN** its repository context contains OpenSpec-specific workflow rules without a second full copy of the general `AGENTS.md` guidance

#### Scenario: Durable repository structure changes

- **WHEN** a change modifies the repository's durable structure, source-of-truth boundaries, or universal workflows
- **THEN** the agent reviews `AGENTS.md` and updates it in the same change if its guidance is inaccurate or incomplete

### Requirement: Agents SHALL hand off unavailable or sensitive operations to the operator

The repository guidance SHALL require agents to stop and provide an explicit operator handoff when a task requires credentials, SSH or other remote access, destructive authority, or capabilities unavailable inside the nono sandbox. Agents SHALL NOT bypass the sandbox, automatically widen its permissions, request raw credentials, or claim that an unperformed operation succeeded.

#### Scenario: A sandbox boundary blocks an operation

- **WHEN** a required filesystem or network operation fails because of the nono sandbox
- **THEN** the agent reports the blocked operation and error, states that it was not performed, and gives the operator manual steps with prerequisites and verification

#### Scenario: A task requires remote or destructive access

- **WHEN** a task requires SSH, remote administration, secret decryption, or a destructive infrastructure operation
- **THEN** the agent does not perform or automatically authorize the operation and instead provides a manual operator procedure without requesting secrets

#### Scenario: A safe read-only capability may be needed

- **WHEN** the operator explicitly asks how to grant additional non-sensitive read-only access
- **THEN** the agent may describe the minimal capability change as an optional operator-controlled action and must not apply it automatically

### Requirement: OpenSpec tasks SHALL distinguish verified work from operator work

OpenSpec task guidance SHALL require tasks to remain incomplete until the described work has been performed and verified. Tasks blocked by sandbox boundaries or awaiting operator action SHALL identify the blocker and the required verification.

#### Scenario: Local validation succeeds

- **WHEN** the agent runs the relevant deterministic validation and observes success
- **THEN** the agent may mark the corresponding validation task complete and report what was run

#### Scenario: Deployment or runtime verification is unavailable

- **WHEN** deployment or runtime verification requires operator access that the agent does not have
- **THEN** the task remains incomplete and records the operator handoff instead of being marked complete based on intent or static inspection
