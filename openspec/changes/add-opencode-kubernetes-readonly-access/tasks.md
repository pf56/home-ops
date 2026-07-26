## 1. Kubernetes Identity

- [x] 1.1 Create an Argo-managed infrastructure chart for the OpenCode access resources and register it with the existing infrastructure ApplicationSet.
- [x] 1.2 Define a dedicated access namespace and ServiceAccount with workload token automount disabled.
- [x] 1.3 Bind the ServiceAccount cluster-wide to the built-in `view` ClusterRole and verify that no Secret, mutation, exec, attach, port-forward, or token-creation permissions are introduced.
- [x] 1.4 Decide whether the operator-managed long-lived ServiceAccount token Secret is declared with generated fields ignored by Argo or kept entirely outside GitOps, and record the decision in the access runbook.

## 2. Host Secret And Nono Route

- [x] 2.1 Add the SOPS secret declaration for the Kubernetes token to `nix/modules/dev/ai.nix` with ownership and permissions suitable for the nono supervisor.
- [ ] 2.2 Add the encrypted `ai/kubernetes-token` value to the host's SOPS data using an operator-provided token; never place the plaintext token in the repository, command output, or task notes.
- [x] 2.3 Configure the generated OpenCode nono profile with a supervisor-side `file://` credential source, the Kubernetes API upstream, phantom-token environment delivery, and GET-only endpoint rules.
- [x] 2.4 Configure the Kubernetes API CA for nono's upstream TLS verification without granting the sandbox access to the administrative kubeconfig or token file.
- [ ] 2.5 Verify the resolved profile with `nono profile validate` and `nono profile show --json`, confirming the token path is not present in filesystem grants and the Kubernetes route is present.

## 3. Non-Secret Kubernetes Client Configuration

- [x] 3.1 Add an immutable Nix-store exec helper that emits Kubernetes `ExecCredential` JSON using only the sandbox-visible phantom token.
- [x] 3.2 Provide a non-secret kubeconfig for the cluster endpoint and configure `KUBECONFIG` for OpenCode-compatible Kubernetes tools.
- [ ] 3.3 Validate kubectl's exec-plugin behavior and TLS trust through nono with a non-mutating Kubernetes discovery request.
- [ ] 3.4 Resolve any kubectl/k9s compatibility issue without falling back to exposing the real token; document an explicitly approved fallback only if the proxy design cannot support the client.

## 4. Operator Bootstrap And Runbook

- [x] 4.1 Add an operator runbook covering administrative prerequisites, placeholder-based token provisioning, SOPS update, Nix deployment, verification, rotation, revocation, and rollback.
- [ ] 4.2 Outside the nono sandbox, deploy or sync the ServiceAccount and ClusterRoleBinding through Argo CD using an administrative kubeconfig.
- [ ] 4.3 Outside the nono sandbox, provision or retrieve the dedicated ServiceAccount token and update the encrypted host SOPS value without exposing the token to OpenCode.
- [x] 4.4 Record the cluster CA source and token Secret lifecycle chosen during bootstrap, including how stale tokens are invalidated.

## 5. Validation And Security Checks

- [x] 5.1 Run Nix formatting and the relevant Nix evaluation/checks for the changed Home Manager configuration.
- [x] 5.2 Run Helm linting and template rendering for the new infrastructure chart and confirm the rendered RBAC objects contain only intended permissions.
- [ ] 5.3 Verify permitted reads such as namespaced resource listing, watching, and pod logs through the OpenCode profile.
- [ ] 5.4 Verify denied access to Secrets, cluster mutations, pod exec/attach, port-forwarding, and ServiceAccount token creation.
- [ ] 5.5 Verify existing model and Git network access remains functional and that the Kubernetes real token is never emitted to the sandbox or sent to another upstream.
- [x] 5.6 Re-check the worktree for plaintext credentials and report any cluster or runtime verification that could not be performed inside the sandbox.
