# OpenCode Kubernetes Access Runbook

This chart grants the `opencode` ServiceAccount in the `opencode-access`
namespace Kubernetes' built-in `view` ClusterRole. It permits read-only access
to namespaced resources and intentionally does not grant Secret, mutation, pod
exec, attach, port-forward, or ServiceAccount token-creation permissions.

The static ServiceAccount token Secret is operator-managed and is not declared
in GitOps. This prevents the token controller's generated data from being
managed or recorded by Argo CD.

## Prerequisites

- Administrative Kubernetes access outside the nono sandbox.
- Access to edit `nix/secrets/pizza.yaml` with SOPS outside the nono sandbox.
- The Kubernetes cluster CA certificate in PEM form. Obtain it from the
  administrative kubeconfig's `certificate-authority-data`; do not grant that
  kubeconfig to OpenCode.

## Bootstrap

1. Reconcile the `opencode-kubernetes-access` Argo CD application and confirm
   the `opencode-access` namespace, `opencode` ServiceAccount, and
   `opencode-view` ClusterRoleBinding exist. Use an administrative kubeconfig
   outside nono, for example:

   ```sh
   argocd app sync opencode-kubernetes-access
   kubectl --kubeconfig <ADMIN_KUBECONFIG> -n opencode-access get serviceaccount opencode
   kubectl --kubeconfig <ADMIN_KUBECONFIG> get clusterrolebinding opencode-view
   ```

2. Create an operator-managed Secret named `opencode-token` in
   `opencode-access` with type `kubernetes.io/service-account-token` and the
   `kubernetes.io/service-account.name: opencode` annotation. Wait for the
   token controller to populate it.

   ```sh
   kubectl --kubeconfig <ADMIN_KUBECONFIG> apply -f - <<'EOF'
   apiVersion: v1
   kind: Secret
   metadata:
     name: opencode-token
     namespace: opencode-access
     annotations:
       kubernetes.io/service-account.name: opencode
   type: kubernetes.io/service-account-token
   EOF
   ```

3. In a private administrative session, set `ai.kubernetes-token` to
   `<TOKEN_RECOVERED_FROM_OPENCODE_TOKEN_SECRET>` and `ai.kubernetes-ca` to
   `<PEM_CA_FROM_ADMIN_KUBECONFIG>` in `nix/secrets/pizza.yaml` through SOPS.
   Do not paste either value in chat, shell history, Git, command output, or
   this runbook.
4. Deploy the Nix configuration for `pizza`, then validate the generated
   `opencode-homelab` profile before using it with OpenCode:

   ```sh
   sudo nixos-rebuild switch --flake .#pizza
   nono profile validate opencode-homelab
   nono profile show opencode-homelab --json
   ```

## Verification

Run these checks through the OpenCode nono profile, not with an administrative
kubeconfig:

- Kubernetes discovery, listing a permitted namespaced resource, watching a
  permitted resource, and reading pod logs succeed.
- Reading Secrets, creating or changing resources, pod exec or attach,
  port-forwarding, and ServiceAccount token creation are denied.
- Model-provider and Git access still work, and the sandbox cannot read
  `/run/secrets/ai/kubernetes-token`, `/run/secrets/ai/kubernetes-ca`, or an
  administrative kubeconfig.

Before using the token, an administrator can validate the RBAC boundary by
impersonating the ServiceAccount. Listing pods is expected to return `yes`;
each other command below is expected to return `no`.

```sh
kubectl --kubeconfig <ADMIN_KUBECONFIG> auth can-i --as=system:serviceaccount:opencode-access:opencode list pods --all-namespaces
kubectl --kubeconfig <ADMIN_KUBECONFIG> auth can-i --as=system:serviceaccount:opencode-access:opencode get secrets --all-namespaces
kubectl --kubeconfig <ADMIN_KUBECONFIG> auth can-i --as=system:serviceaccount:opencode-access:opencode create deployments --all-namespaces
kubectl --kubeconfig <ADMIN_KUBECONFIG> auth can-i --as=system:serviceaccount:opencode-access:opencode create pods/exec --all-namespaces
kubectl --kubeconfig <ADMIN_KUBECONFIG> auth can-i --as=system:serviceaccount:opencode-access:opencode create pods/portforward --all-namespaces
kubectl --kubeconfig <ADMIN_KUBECONFIG> auth can-i --as=system:serviceaccount:opencode-access:opencode create serviceaccounts/token --all-namespaces
```

## Rotation And Revocation

1. Create a replacement operator-managed token Secret with a distinct name.
2. Update only the encrypted `ai.kubernetes-token` value through SOPS and
   deploy the Nix configuration.
3. Verify a read-only request through the OpenCode profile.
4. Delete the previous token Secret to invalidate its token. Do not remove the
   ServiceAccount or ClusterRoleBinding while validating the replacement.

To revoke access immediately, delete the active operator-managed token Secret.
For a full rollback, remove the Nix profile route and SOPS entries, reconcile
the chart removal, and confirm OpenCode can no longer reach the Kubernetes API.
