## ADDED Requirements

### Requirement: Dedicated read-only Kubernetes identity

The system SHALL provide a dedicated Kubernetes ServiceAccount for OpenCode and SHALL bind it cluster-wide to the built-in `view` ClusterRole. The binding MUST NOT grant access to Kubernetes Secret data, resource mutation verbs, pod exec or attach, port-forwarding, token creation, or other write-capable subresources.

#### Scenario: OpenCode reads namespaced resources across namespaces

- **WHEN** OpenCode authenticates with the dedicated ServiceAccount and requests permitted namespaced resources in any namespace
- **THEN** Kubernetes SHALL allow read-only `get`, `list`, and `watch` operations covered by the `view` role

#### Scenario: OpenCode cannot read Secret data

- **WHEN** OpenCode requests Kubernetes Secret objects or Secret data with the dedicated identity
- **THEN** Kubernetes SHALL deny the request

#### Scenario: OpenCode cannot mutate cluster resources

- **WHEN** OpenCode attempts to create, update, patch, or delete a Kubernetes resource with the dedicated identity
- **THEN** Kubernetes SHALL deny the request

#### Scenario: OpenCode cannot use privileged pod subresources

- **WHEN** OpenCode attempts pod exec, attach, port-forward, or ServiceAccount token creation with the dedicated identity
- **THEN** Kubernetes SHALL deny the request

### Requirement: Secret stays outside the sandbox

The real ServiceAccount token SHALL be stored in the encrypted host SOPS secret set and SHALL be readable by the nono supervisor for credential mediation. The OpenCode sandbox MUST NOT have filesystem read access to the decrypted token path, the existing administrative kubeconfig, or any file containing the real token.

#### Scenario: Host configuration contains no plaintext token

- **WHEN** the repository and generated configuration are inspected
- **THEN** the ServiceAccount token SHALL appear only as encrypted SOPS data or as a runtime secret outside the sandbox

#### Scenario: Sandbox attempts direct token access

- **WHEN** OpenCode attempts to read the decrypted Kubernetes token path
- **THEN** nono SHALL deny the filesystem operation

#### Scenario: Existing administrative kubeconfig remains protected

- **WHEN** OpenCode attempts to read the existing administrative kubeconfig
- **THEN** nono SHALL continue to deny the filesystem operation

### Requirement: Nono mediates Kubernetes authentication

The generated OpenCode nono profile SHALL define a Kubernetes custom credential route whose supervisor-side credential source is the SOPS token, whose upstream is the configured Kubernetes API endpoint, and whose sandbox-visible credential is a phantom token. The real token MUST NOT be emitted to the sandbox or injected toward any other upstream.

#### Scenario: Kubernetes request receives the real credential only at the API upstream

- **WHEN** OpenCode sends a request using the phantom credential to the configured Kubernetes API endpoint
- **THEN** nono SHALL replace the phantom credential with the real ServiceAccount token only for that upstream request

#### Scenario: Phantom credential is used outside the Kubernetes upstream

- **WHEN** OpenCode sends the sandbox-visible phantom credential to another upstream
- **THEN** nono SHALL NOT inject the Kubernetes ServiceAccount token there

### Requirement: Kubernetes client configuration is non-secret

The system SHALL provide OpenCode with a kubeconfig and fixed credential helper that contain no real bearer token or administrative client key. The profile SHALL set the client configuration as the default Kubernetes configuration for OpenCode-compatible tools.

#### Scenario: kubectl performs discovery through the configured profile

- **WHEN** OpenCode invokes kubectl without selecting the administrative kubeconfig
- **THEN** kubectl SHALL use the non-secret OpenCode configuration and authenticate through the nono phantom credential flow

#### Scenario: Credential helper output is generated at runtime

- **WHEN** kubectl invokes the configured exec credential helper
- **THEN** the helper SHALL emit Kubernetes ExecCredential data containing only the sandbox-visible phantom credential

### Requirement: Credential route permits read-only API traffic

The Kubernetes credential route SHALL permit only GET requests required for Kubernetes discovery and read-only API access. The route MUST preserve OpenCode's existing general network access for non-Kubernetes providers and Git operations.

#### Scenario: Read-only API request succeeds

- **WHEN** OpenCode performs a GET request for Kubernetes discovery, a permitted API resource, a watch, or pod logs
- **THEN** the request SHALL be eligible for proxy forwarding and subject to the ServiceAccount RBAC permissions

#### Scenario: Mutating HTTP request is blocked by the route

- **WHEN** OpenCode sends a POST, PUT, PATCH, or DELETE request through the Kubernetes credential route
- **THEN** the nono route SHALL reject the request before it reaches the Kubernetes API

#### Scenario: Existing non-Kubernetes network remains available

- **WHEN** OpenCode connects to its configured model or Git services
- **THEN** the change SHALL not globally block those existing connections

### Requirement: Bootstrap and rotation are operator-verifiable

The change SHALL document the administrative prerequisites, bootstrap procedure, verification checks, rotation procedure, and rollback procedure for the ServiceAccount token. Repository and sandbox validation MUST distinguish work performed locally from cluster operations requiring an administrative kubeconfig.

#### Scenario: Operator bootstraps the credential

- **WHEN** an operator with administrative cluster access follows the bootstrap procedure
- **THEN** the dedicated ServiceAccount, read-only binding, host SOPS token, and generated profile SHALL be connected without committing plaintext credentials

#### Scenario: Operator verifies authorization boundaries

- **WHEN** the operator executes the documented positive and negative checks
- **THEN** permitted reads SHALL succeed and Secret or mutation checks SHALL be denied

#### Scenario: Operator rotates or revokes access

- **WHEN** the operator follows the documented rotation or rollback procedure
- **THEN** the old token SHALL be revoked or invalidated and OpenCode SHALL no longer authenticate with it
