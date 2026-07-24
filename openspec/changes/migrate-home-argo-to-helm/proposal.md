## Why

`kubernetes/clusters/home-argo/` is the lone cluster bootstrap that uses Kustomize's Helm generator, while the rest of the GitOps repository uses local Helm wrapper charts. Moving it to the established chart layout removes the special Kustomize Helm build requirement and makes its configuration consistent with the infrastructure it manages.

## What Changes

- Replace the `home-argo` Kustomization and generated-chart cache with a local Helm wrapper chart pinned to the existing upstream Argo CD chart version.
- Render the Argo CD chart, namespace, Argo resources, and Traefik routes through the wrapper chart without changing their deployed identities.
- Preserve `argocd` as the Helm release name even though the self-managing Argo Application is named `argo-cd`.
- Transition in two GitOps phases so the live Application receives its Helm release name before Argo renders the new chart.
- Update the bootstrap script to render the local chart and apply manifests, leaving Argo CD as the long-term resource owner.
- Remove the now-unused `kustomize.buildOptions: --enable-helm` configuration.

## Capabilities

### New Capabilities
- `home-argo-helm-chart`: Helm-based rendering and bootstrap of the home Argo CD installation with stable resource identities.

### Modified Capabilities
- None.

## Impact

- Affects `kubernetes/clusters/home-argo/`, including its bootstrap command and self-managing Argo CD Application.
- Adds a pinned Helm dependency on `https://argoproj.github.io/argo-helm` at the existing `argo-cd` chart version.
- Changes the Argo CD application's source type from Kustomize to Helm after the staged transition, without changing its services, CRDs, routes, or notification configuration.
