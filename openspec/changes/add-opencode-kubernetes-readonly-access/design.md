## Context

OpenCode runs inside the generated `opencode-homelab` nono profile from `nix/modules/dev/ai.nix`. The profile deliberately inherits `deny_credentials`, so the existing administrative kubeconfig is not readable. The Kubernetes API endpoint is declared in `kubernetes/talos/talconfig.yaml`, and Argo CD discovers infrastructure charts through `kubernetes/infrastructure/root`.

This change crosses Kubernetes RBAC, GitOps chart provisioning, encrypted host secrets, Home Manager configuration, and nono's credential proxy. The implementation must preserve OpenCode's existing model and Git network access while ensuring that Kubernetes authority is read-only and the real bearer token never enters the sandbox.

## Goals / Non-Goals

**Goals:**

- Provide OpenCode with cluster-wide read access to namespaced Kubernetes resources through a dedicated identity.
- Keep the real ServiceAccount token encrypted at rest and supervisor-only at runtime.
- Make a normal Kubernetes client workflow available through a non-secret kubeconfig and fixed exec credential helper.
- Add defense-in-depth GET-only mediation for requests using the OpenCode Kubernetes credential.
- Keep bootstrap, verification, rotation, and revocation explicit when administrative cluster access is required.

**Non-Goals:**

- Grant access to Kubernetes Secrets, cluster mutation, pod exec/attach, port-forwarding, or other write-capable subresources.
- Grant broad cluster-scoped inventory access such as Nodes, PersistentVolumes, StorageClasses, or CRDs unless a later requirement adds it.
- Replace or alter the existing administrative kubeconfig.
- Restrict OpenCode's general model, GitHub, or Git network access.
- Introduce OIDC, a new Kubernetes authentication provider, or a general-purpose Kubernetes MCP server.

## Decisions

### Use a dedicated ServiceAccount and the built-in `view` role

Create a ServiceAccount in a dedicated access namespace and bind it with a ClusterRoleBinding to Kubernetes' built-in `view` ClusterRole. This gives read-only access to namespaced resources across namespaces while avoiding a custom copy of a large, version-sensitive rule set. The ServiceAccount will not receive permissions for Secrets or mutation subresources, and its token will not be automounted into workloads.

An explicit custom cluster-reader role was considered, but it would either duplicate the built-in view rules or require broad wildcard rules that could accidentally include Secrets. Cluster-scoped inventory is intentionally excluded from this change and can be added with narrowly scoped rules later.

### Keep a static token in SOPS and mediate it through nono

Use a manually provisioned long-lived ServiceAccount token as the initial credential lifecycle. The token will be stored as an encrypted key in the existing `pizza` SOPS file and exposed to the nono supervisor through its decrypted `/run/secrets` path. The sandbox will not receive filesystem access to that path.

Kubernetes' short-lived TokenRequest flow was considered and is preferable for high-security environments, but it requires a host-side refresh mechanism and privileged bootstrap credential. Manual rotation is an explicit trade-off for this homelab change; rotation and revocation procedures are part of the implementation.

### Use a nono custom credential route

Configure a nono `custom_credentials` route whose upstream is the Kubernetes API endpoint and whose `credential_key` is a supervisor-side `file://` reference to the SOPS secret. The route will provide a phantom bearer token to the sandbox through an environment variable and inject the real token only for the configured Kubernetes upstream.

The route will use endpoint rules that permit only `GET` requests for Kubernetes discovery and API paths. Kubernetes RBAC remains the authoritative permission boundary; the proxy rule is defense in depth and prevents the real token from being useful if copied from the sandbox-visible environment.

Granting exact read access to a dedicated kubeconfig was considered, but it would expose a bearer credential to the sandbox. Adding a bare nono domain allowlist was also rejected because the current profile intentionally permits general network access and a bare domain entry does not provide account-specific authorization.

### Generate a non-secret kubeconfig and exec helper

Provide a fixed kubeconfig through Home Manager and set `KUBECONFIG` in the profile. The kubeconfig will contain only the cluster endpoint, context, and an exec credential configuration. A small immutable helper in the Nix store will emit Kubernetes `ExecCredential` JSON using the sandbox-visible phantom token.

The original cluster CA will remain supervisor-side for upstream verification. The client-side trust behavior through nono's TLS interception must be validated with kubectl; the implementation may use nono's generated trust bundle and standard CA environment variables rather than putting a private credential or administrative kubeconfig in the client configuration.

### Provision RBAC through a dedicated infrastructure chart

Add a small chart under `kubernetes/infrastructure/` with an ApplicationSet `config.json`, a dedicated namespace, the ServiceAccount, and the ClusterRoleBinding. This follows the repository's existing Argo-managed infrastructure pattern and keeps cluster access resources separate from application workloads.

The token Secret used to obtain the initial static token will be operator-managed or otherwise excluded from GitOps data management so generated token data is never committed. The host-side copy remains encrypted in SOPS.

## Risks / Trade-offs

- **[Risk]** A static ServiceAccount token remains valid until it is rotated or revoked. -> Keep it encrypted, never grant sandbox filesystem access, mediate it through nono, bind only `view`, document rotation, and provide a revocation procedure.
- **[Risk]** Kubernetes' built-in `view` role does not provide cluster-scoped inventory or arbitrary CRD visibility. -> Document the exact scope and add explicit rules only when a concrete read requirement is identified.
- **[Risk]** Nono TLS interception or kubectl exec-plugin behavior may not work with the private Kubernetes API CA. -> Treat this as an implementation spike and validate with a non-mutating request before enabling the final profile. Do not fall back to an exact-file kubeconfig grant because it would expose the real bearer token to the sandbox; stop the change and redesign the credential mediation instead.
- **[Risk]** GET-only proxy mediation can block helper commands such as `kubectl auth can-i`, which use POST-based review APIs. -> Verify permissions with non-mutating resource requests and perform impersonated authorization checks outside the sandbox when operator access is available.
- **[Risk]** A generated token Secret and the SOPS copy can diverge. -> Record the source Secret and rotation sequence, update SOPS in the same rotation window, and revoke the old token before considering rotation complete.

## Migration Plan

1. Deploy the ServiceAccount and RBAC chart through Argo CD.
2. Using an administrative kubeconfig outside nono, provision or retrieve a token for the dedicated ServiceAccount and place only the token value into the encrypted host SOPS key.
3. Apply the Nix/Home Manager configuration and validate the resolved nono profile without exposing the secret path to the sandbox.
4. Run non-mutating OpenCode-side checks for discovery and permitted resource reads, then verify forbidden Secret and mutation operations.
5. To roll back, remove the profile route and host secret, revoke/delete the dedicated token, and remove the Argo-managed ServiceAccount and binding.

## Open Questions

- Which exact non-secret cluster CA file or data source should be used for nono's upstream `tls_ca` setting?
- Should the operator-managed token Secret be declared as a minimal Argo resource with generated data ignored, or remain entirely out of GitOps?
- Which fixed Nix helper packaging pattern best satisfies nono's executable trust checks while remaining reusable by kubectl and k9s?
