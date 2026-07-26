## Why

OpenCode currently cannot inspect the Kubernetes cluster because nono blocks the existing kubeconfig as a credential-bearing file. The existing kubeconfig also represents broader administrative authority than an AI coding agent should receive, so access should be introduced with a dedicated read-only Kubernetes identity and a credential path that keeps the real token outside the sandbox.

## What Changes

- Add a dedicated Kubernetes ServiceAccount for OpenCode.
- Grant that identity cluster-wide read-only `view` access without access to Secrets or mutation subresources.
- Store the ServiceAccount token in the existing encrypted host SOPS secret set.
- Extend the generated OpenCode nono profile with a Kubernetes credential route that injects the real token only toward the Kubernetes API and permits read-only HTTP operations.
- Provide OpenCode with a non-secret kubeconfig and credential helper rather than exposing the existing administrative kubeconfig.
- Document bootstrap, verification, token rotation, and rollback procedures that require operator access to the cluster.

## Capabilities

### New Capabilities

- `opencode-kubernetes-access`: Provides OpenCode with authenticated, cluster-wide, read-only Kubernetes API access while keeping the bearer credential outside the sandbox.

### Modified Capabilities

- None.

## Impact

- Kubernetes GitOps resources under `kubernetes/infrastructure/` for the ServiceAccount and RBAC binding.
- NixOS/Home Manager AI configuration under `nix/modules/dev/ai.nix`.
- Encrypted host secrets under `nix/secrets/pizza.yaml`; no plaintext token may be committed.
- The nono profile and Kubernetes client configuration used by OpenCode.
- Operator bootstrap and rotation procedures requiring an administrative kubeconfig outside the nono sandbox.
